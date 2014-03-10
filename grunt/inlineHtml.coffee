fs = require 'fs'
path = require 'path'

module.exports = (grunt)->
  grunt.task.registerMultiTask 'inlineHtml', (env)->
    #ref = grunt.config.get 'ref'
    #console.log @options()
    #console.log @files
    #console.log @files, @options(), @data
    @files.forEach (filePair)=>
      filePair.src.forEach (src)=>
        #console.log src
        content = fs.readFileSync(src).toString()
        found = false
        content = content.replace /<inline\s+src=['"]([^'"]+)['"]\/?>/ig, (matchedWord, fn)->
          console.log 'html inline:', matchedWord, '->', fn, '->', path.join path.dirname(src), fn
          found = true
          inlineFn = path.join path.dirname(src), fn
          fs.readFileSync inlineFn
        if found
          dest = path.join @data.dest, path.relative(@data.cwd, src)
          grunt.file.write dest, content
          #console.log dest
          #do ->

  dev:
    expand: true
    cwd: '<%=ref.src%>'
    src: ['**/*.html', '!templates/**/*.html',
          '!inline/**/*.html']
    dest: '<%=ref.dev%>'