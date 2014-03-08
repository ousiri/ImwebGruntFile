md5 = require 'MD5'
fs = require 'fs'
path = require 'path'

module.exports = (grunt)->
  #output = 'md5-map.json'
  fileMap = {}
  #regHtml = /<(?:img|link|script)[^>]*\s(?:href|src)=['"]([^'"]+)['"][^>]*\/?>/ig
  regCss = /url\(([^)]+)\)/ig
  regLoadJS = /\$\.http\.loadScript\(['"]([^'"]+)['"]/g
  regLoadCss = /\$\.http\.loadCss\(['"]([^'"]+)['"]/g


  getMd5 = (content)->
    md5(content).substr 0, 5

  processImg = (files, options)->
    files.forEach (filePair)->
      filePair.src.forEach (src)->
        if path.extname(src).match /(png|jpg|jpeg|gif)$/
          fileMd5 = getMd5 fs.readFileSync src
          dest = path.join path.dirname(src), "#{fileMd5}_#{path.basename(src)}"
          fileMap[path.relative options.parentDir, src] = path.relative options.parentDir, dest

  processCss = (files, options)->
    files.forEach (filePair)->
      filePair.src.forEach (src)->
        if src.match /css$/
          content = fs.readFileSync src
          ext = ''
          content.replace regCss, (matchedWord, fn)->

          #fileMd5 = getMd5 fs.readFileSync src
          dest = path.join path.dirname(src), "#{fileMd5}_#{path.basename(src)}"
          fileMap[path.relative options.parentDir, src] = path.relative options.parentDir, dest


  grunt.task.registerMultiTask 'md5', ->
    options = @options()
    files = @files
    processImg.call @, files, options
    processCss.call @, files, options
    #console.log options
    ###@files.forEach (filePair)->
      filePair.src.forEach (src)->
        fileMd5 = getMd5 fs.readFileSync src
        dest = path.join path.dirname(src), "#{fileMd5}_#{path.basename(src)}"
        grunt.file.copy src, dest
        grunt.file.delete src
        #fileMap[src] = dest

        fileMap[path.relative options.parentDir, src] = path.relative options.parentDir, dest
    console.log fileMap###
    grunt.config.set 'md5Map', fileMap
    console.log fileMap

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

