path = require 'path'

module.exports = (grunt)->

  grunt.task.registerTask 'imgminClean', ()->
    cleanConf = grunt.config.get 'imgminCleanConf'
    for f in cleanConf
      if grunt.file.exists f
        grunt.file.delete f

  grunt.task.registerMultiTask 'imgmin', ()->
    imgConf = {}
    cleanSrc = []
    count = 0
    @files.forEach (filePair)=>
      filePair.src.forEach (src)->
        imgConf["task#{count}"] =
          src: src,
          dest: path.dirname(filePair.dest) + '/'
        count += 1
        cleanSrc.push "#{filePair.dest}.bak"
    grunt.config.set 'img', imgConf
    grunt.config.set 'imgminCleanConf', cleanSrc
    grunt.loadNpmTasks 'grunt-img'
    grunt.task.run ['img', 'imgminClean']

  src:
    expand: true
    cwd: '<%=ref.src%>'
    src: ['**/*.{png,jpg,jpeg,gif}']
    dest: '<%=ref.src%>'
  dev:
    expand: true,
    cwd: '<%=ref.src%>'
    src: ['**/*.{png,jpg,jpeg,gif}']
    dest: '<%=ref.dev%>'