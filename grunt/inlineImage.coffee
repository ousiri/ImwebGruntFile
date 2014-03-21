mime = require 'mime'
path = require 'path'
fs = require 'fs'

module.exports = (grunt)->

  getDataURI = (mimeType, img)->
    "data:#{mimeType};base64,#{img.toString('base64')}"

  grunt.task.registerMultiTask 'inlineImage', ->
    regCss = /:\s*url\(['"]?([^'")]+)['"]?\)/ig
    regSkip = /\+|<%/g
    regParams = /(?:\?|#).*$/
    flagString = '__inline'
    @files.forEach (filePair)->
      filePair.src.forEach (filePath)->
        content = grunt.file.read(filePath).toString()
        flag = false
        content = content.replace regCss, (matchedWord, src)->
          #console.log matchedWord, src, path.join(path.dirname(filePath), src)
          if src.indexOf(flagString) != -1
            src = src.replace regParams, ''
            imgSrc = path.join(path.dirname(filePath), src)
            img = fs.readFileSync imgSrc
            matchedWord = matchedWord.replace src, getDataURI(mime.lookup(src), img)
            flag = true
          matchedWord
        if flag
          console.log filePair.dest, content
          grunt.file.write filePair.dest, content

      console.log filePair.dest


  tmp:
    expand: true
    cwd: '<%=ref.tmp%>'
    src: ['**/*.css']
    dest: '<%=ref.tmp%>'
