module.exports = (grunt)->
  fs = require 'fs'
  path = require 'path'

  regHtml = /<(?:img|link|script)[^>]*\s(?:href|src)=['"]([^'"]+)['"][^>]*\/?>/ig
  regCss = /url\(['"]?([^'")]+)['"]?\)/ig
  regLoadJS = /\$\.http\.loadScript\(['"]([^'"]+)['"]/g
  regLoadCss = /\$\.http\.loadCss\(['"]([^'"]+)['"]/g
  regSkip = /\+|<%/g

  supportedTypes =
    html: 'html',
    css: 'css'

  fileMap = {}

  processHtml = (content, filePath, options)->
    #console.log 'options: ', options
    imgCdn = options.img or options.cdn
    jsCdn = options.js or options.cdn
    cssCdn = options.css or options.cdn
    if imgCdn and jsCdn and cssCdn
      content = content.replace(regHtml, (matchedWord, src)->
        type = path.extname(src).replace(/^\./, '')
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
      ).replace(regLoadJS, (matchedWord, src)->
        if src.match regSkip
          console.log 'skipping', matchedWord
          matchedWord
        else
          matchedWord.replace src, cdnUrl.call(@, src, filePath, jsCdn)
      ).replace(regLoadCss, (matchedWord, src)->
        if src.match regSkip
          console.log 'skipping', matchedWord
          matchedWord
        else
          matchedWord.replace src, cdnUrl.call(@, src, filePath, cssCdn)
      )
    content

  processCss = (content, filePath, options) ->
    cdn = options.img or options.cdn
    if cdn
      content = content.replace regCss, (matchedWord, src)->
        matchedWord.replace src, cdnUrl.call(@, src, filePath, cdn)
    content

  cdnUrl = (src, filePath, cdn)->
    if src.match(/^https?:\/\//i) or src.match(/^\/\//) or src.match(/^data:/i)
      console.log 'Skipping due to', src, 'matches absolute url'
      return src
    relative = path.join path.dirname(filePath), src
    #console.log 'cdnUrl: ', filePath, src, relative, fileMap[relative]
    # todo fix usemin bug
    p = path.join(cdn, fileMap[relative] or relative).replace(/\\/g, '/').replace(/:\/(\w)/, '://$1')
    console.log 'found a match:', src, '->', relative.replace(/\\/g, '/'), '->',  p
    p

  grunt.task.registerMultiTask 'cdn', ()->
    #console.log @options()
    options = @options()
    files = @filesSrc
    fileMap = grunt.config.get 'md5Map'
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