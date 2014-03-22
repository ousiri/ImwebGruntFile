module.exports = (grunt)->
  fs = require 'fs'
  path = require 'path'

  #regHtml = /<(?:img|link|script)[^>]*\s(?:href|src)=['"]([^'"]+)['"][^>]*\/?>/ig
  #regCss = /:\s*url\(['"]?([^'")]+)['"]?\)/ig
  #regLoadJS = /\$\.http\.loadScript\(['"]([^'"]+)['"]/g
  #regLoadCss = /\$\.http\.loadCss\(['"]([^'"]+)['"]/g
  #regSkip = /\+|<%/g
  #regParams = /(?:\?|#).*$/

  supportedTypes =
    html: 'html',
    css: 'css',
    js: 'js'

  fileMap = {}

  regs = {}

  disabledFeatures = false

  processHtml = (content, filePath, options)->
    #console.log 'options: ', options
    imgCdn = options.img or options.cdn
    jsCdn = options.js or options.cdn
    cssCdn = options.css or options.cdn
    if imgCdn and jsCdn and cssCdn
      #console.log content
      content = content.replace(regs.html, (matchedWord, src)->
        type = path.extname(src).replace(regs.params, '').replace(/^\./, '')
        if type=='js'
          cdn = jsCdn
        else if type=='css'
          cdn = cssCdn
        else if type.match /^(png|jpg|jpeg|gif)$/
          cdn = imgCdn
        #console.log 'cdn debug: ', src, filePath, cdn, type
        matchedWord.replace src, cdnUrl.call(@, src, filePath, cdn)
      ).replace(regs.css, (matchedWord, src)->
        if src.match regs.skip #skip js script, it's just convenient
          console.log 'skipping', matchedWord.substr(0, 30)
          matchedWord
        else
          matchedWord.replace src, cdnUrl.call(@, src, filePath, imgCdn);
      ).replace(regs.loadJs, (loadFunc, srcs)->
        newSrcs = srcs.replace regs.extract, (srcWithQuote, src)->
          if src.match regs.skip
            console.log 'skipping', srcWithQuote
            srcWithQuote
          else
            srcWithQuote.replace src, cdnUrl.call(@, src, filePath, jsCdn)
        loadFunc.replace srcs, newSrcs
      ).replace(regs.loadCss, (loadFunc, srcs)->
        newSrcs = srcs.replace regs.extract, (srcWithQuote, src)->
          if src.match regs.skip
            console.log 'skipping', srcWithQuote
            srcWithQuote
          else
            srcWithQuote.replace src, cdnUrl.call(@, src, filePath, cssCdn)
        loadFunc.replace srcs, newSrcs
      )
    content

  processCss = (content, filePath, options) ->
    cdn = options.img or options.cdn
    if cdn
      content = content.replace regs.css, (matchedWord, src)->
        matchedWord.replace src, cdnUrl.call(@, src, filePath, cdn)
    content

  processJs = (content, filePath, options)->
    jsCdn = options.js or options.cdn
    cssCdn = options.css or options.cdn
    parentDir = options.parentDir
    if jsCdn and cssCdn
      content = content.replace(regs.loadJs, (loadFunc, srcs)->
        newSrcs = srcs.replace regs.extract, (srcWithQuote, src)->
          if src.match regs.skip
            console.log 'skipping', srcWithQuote
            srcWithQuote
          else
            srcWithQuote.replace src, cdnUrl.call(@, src, parentDir, jsCdn)
        loadFunc.replace srcs, newSrcs
      ).replace(regs.loadCss, (loadFunc, srcs)->
        newSrcs = srcs.replace regs.extract, (srcWithQuote, src)->
          if src.match regs.skip
            console.log 'skipping', srcWithQuote
            srcWithQuote
          else
            srcWithQuote.replace src, cdnUrl.call(@, src, parentDir, cssCdn)
        loadFunc.replace srcs, newSrcs
      )
      ###.replace(regHtml, (matchedWord, src)->
        type = path.extname(src).replace(regParams, '').replace(/^\./, '')
        if type=='js'
          cdn = jsCdn
        else if type=='css'
          cdn = cssCdn
        else if type.match /^(png|jpg|jpeg|gif)$/
          cdn = imgCdn
        #console.log 'cdn debug: ', src, filePath, cdn, type
        matchedWord.replace src, cdnUrl.call(@, src, filePath, cdn)
      ).replace(regCss, (matchedWord, src)->
        if src.match regSkip #skip js script, it's just convenient
          console.log 'skipping', matchedWord
          matchedWord
        else
          matchedWord.replace src, cdnUrl.call(@, src, filePath, imgCdn);
      )###
    content


  cdnUrl = (src, filePath, cdn)->
    if src.match regs.abs
      console.log 'Skipping due to', src.substr(0, 50), 'matches absolute url'
      return src
    relative = path.join path.dirname(filePath), src
    filename = relative.replace regs.params, ''
    #console.log 'cdnUrl: ', filePath, src, relative, fileMap[relative]
    # todo fix usemin bug
    #console.log 'found a match', src, '->', relative
    p = path.join(cdn, fileMap[filename] or filename).replace(/\\/g, '/').replace(/:\/(\w)/, '://$1') + (relative.match(regs.params) or [''])[0]
    console.log 'found a match:', src, '->', relative.replace(/\\/g, '/'), '->',  p
    p

  grunt.task.registerMultiTask 'cdn', ->
    #console.log @options()
    options = @options()
    files = @filesSrc
    fileMap = grunt.config.get 'md5Map'
    regs = grunt.config.get 'regs'
    disabledFeatures = grunt.config.get 'disabledFeatures'
    disabledImageMd5 = disabledFeatures.indexOf("imageMd5") != -1
    files.forEach (filePath)=>
      type = path.extname(filePath).replace /^./, ''
      if not supportedTypes[type]
        return
      content = grunt.file.read(filePath).toString()
      rFilePath = path.relative options.parentDir, filePath
      if supportedTypes[type] == 'html'
        content = processHtml.call @, content, rFilePath, options
      else if supportedTypes[type] == 'css'
        content = processCss.call @, content, rFilePath, options
      else if supportedTypes[type] == 'js'
        content = processJs.call @, content, rFilePath, options
      grunt.file.write filePath, content
  #console.log 'grunt.config.cdnRoot', grunt.config.get 'cdnRoot'
  dist:
    options:
      cdn: 'http://test.cdn.com/test/'
      img: 'http://3.cdn.com/test/'
      js: 'http://1.cdn.com/test/'
      css: 'http://1.cdn.com/test/'
      parentDir: '<%=ref.dist%>'
    src: ['<%=ref.dist%>**/*.*']