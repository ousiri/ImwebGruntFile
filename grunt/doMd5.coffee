md5 = require 'MD5'
fs = require 'fs'
path = require 'path'

module.exports = (grunt)->
  #output = 'md5-map.json'
  fileMap = {}
  fileMd5Map = {}
  #regHtml = /<(?:img|link|script)[^>]*\s(?:href|src)=['"]([^'"]+)['"][^>]*\/?>/ig
  ###regCss = /:\s*url\(([^)]+)\)/ig
  regLoadJs = /\$\.http\.loadScript\(['"]([^'"]+)['"]/g
  regLoadCss = /\$\.http\.loadCss\(['"]([^'"]+)['"]/g
  regSkip = /\+|\<%|^https?:\/\/|^\/\/|^data:/ig
  regParams = /(?:\?|#).*$/###
  regs = {}
  getMd5 = (content)->
    md5(content).substr 0, 5

  moveFile = (src, dest)->
    grunt.file.copy src, dest
    grunt.file.delete src

  processImg = (files, options)->
    files.forEach (filePair)->
      filePair.src.forEach (src)->
        if src.match /(png|jpg|jpeg|gif)$/
          fileMd5 = getMd5 fs.readFileSync src
          dest = path.join path.dirname(src), "#{fileMd5}_#{path.basename(src)}"
          relativePath = path.relative options.parentDir, src
          fileMap[relativePath] = path.relative options.parentDir, dest
          fileMd5Map[relativePath] = fileMd5
          moveFile src, dest

  processCss = (files, options)->
    files.forEach (filePair)->
      filePair.src.forEach (src)->
        if src.match /css$/
          content = fs.readFileSync(src).toString()
          ext = []
          content.replace regs.css, (matchedWord, fn)->
            if not fn.match regs.abs
              fn = fn.replace regs.params, ''
              ext.push fileMap[path.relative(options.parentDir, path.join(path.dirname(src), fn.replace(regs.params, '')))]
            matchedWord
          console.log 'css file:', src, ext
          fileMd5 = getMd5 content+ext.join('-')
          dest = path.join path.dirname(src), "#{fileMd5}_#{path.basename(src)}"
          relativePath = path.relative options.parentDir, src
          fileMap[relativePath] = path.relative options.parentDir, dest
          fileMd5Map[relativePath] = fileMd5
          moveFile src, dest

  processJs = (files, options)->
    contents = {}
    jsDeps = {}
    needDeepProcess = false
    relativeMap = {}
    files.forEach (filePair)->
      filePair.src.forEach (filePath)->
        if filePath.match /js$/
          content = fs.readFileSync(filePath).toString()
          jsDeps[filePath] = []
          content.replace(regs.loadCss, (loadFunc, srcs)->
            srcs.replace regs.extract, (srcWithQuote, src)->
              if not src.match regs.abs
                src = src.replace regs.params, ''
                jsDeps[filePath].push src
                needDeepProcess = true
              srcWithQuote
            loadFunc
          ).replace(regs.loadJs, (loadFunc, srcs)->
            srcs.replace regs.extract, (srcWithQuote, src)->
              if not src.match regs.abs
                src = src.replace regs.params, ''
                jsDeps[filePath].push src
                needDeepProcess = true
              srcWithQuote
            loadFunc
          )
          contents[filePath] = content
          relativeMap[filePath] = path.relative options.parentDir, filePath
    for src, content of contents
      fileMd5Map[relativeMap[src]] = getMd5 content
    #console.log 'fileMd5Map', fileMd5Map
    if needDeepProcess
      count = 0
      preFileMapStr = ''
      postFileMapStr = JSON.stringify fileMd5Map
      while preFileMapStr!=postFileMapStr and count<10 # in case infinite loop
        preFileMapStr = postFileMapStr
        for src, content of contents
          fileMd5Map[relativeMap[src]] = getMd5 content+jsDeps[src].map((fn)->fileMd5Map[fn]).join('-')
        postFileMapStr = JSON.stringify fileMd5Map
        #console.log 'preFileMapStr:', preFileMapStr
        #console.log 'postFileMapStr:', postFileMapStr
        #console.log 'count: ', count
        count += 1
      if count==10
        console.log 'md5 reaches maxinum loop, check if there is circular reference for js file'
      #console.log 'fileMd5Map', fileMd5Map
    #console.log 'jsDeps:', jsDeps
    for src of contents
      dest = path.join path.dirname(src), "#{fileMd5Map[relativeMap[src]]}_#{path.basename(src)}"
      fileMap[relativeMap[src]] = path.relative options.parentDir, dest
      moveFile src, dest
    console.log 'jsDeps', jsDeps

  grunt.task.registerMultiTask 'md5', ->
    options = @options()
    files = @files
    cur = new Date()
    regs = grunt.config.get 'regs'
    processImg.call @, files, options
    imgTime = new Date()
    console.log 'process img used: ', imgTime-cur, 'ms'
    processCss.call @, files, options
    cssTime = new Date()
    console.log 'process css used: ', cssTime-imgTime, 'ms'
    processJs.call @, files, options
    jsTime = new Date()
    console.log 'process js used: ', jsTime-cssTime, 'ms'
    console.log 'fileMd5Map', fileMd5Map
    grunt.config.set 'md5Map', fileMap
    console.log 'fileMap:', fileMap

  grunt.task.registerTask 'doMd5', ()->
    config =
      all:
        options:
          parentDir: '<%=ref.dist%>'
        expand: true,
        cwd: '<%=ref.dist%>'
        src: ['**/*.{css,js,png,jpg,jpeg,gif,ico}']
        dest: '<%=ref.dist%>'
    grunt.config.set 'md5', config
    grunt.task.run ['md5:all']
  {}

