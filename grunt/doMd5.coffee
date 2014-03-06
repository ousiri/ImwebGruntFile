md5 = require 'MD5'
fs = require 'fs'
path = require 'path'

module.exports = (grunt)->
  #output = 'md5-map.json'
  fileMap = {}

  grunt.task.registerMultiTask 'md5', ->
    options = @options()
    console.log options
    @files.forEach (filePair)->
      filePair.src.forEach (src)->
        fileMd5 = md5(fs.readFileSync(src)).substr(0, 5)
        dest = path.join path.dirname(src), "#{fileMd5}_#{path.basename(src)}"
        grunt.file.copy src, dest
        grunt.file.delete src
        #fileMap[src] = dest

        fileMap[path.relative options.parentDir, src] = path.relative options.parentDir, dest
    console.log fileMap
    grunt.config.set 'md5Map', fileMap

  grunt.task.registerTask 'doMd5', (env)->
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

