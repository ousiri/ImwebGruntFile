module.exports = (grunt)->

  grunt.task.registerTask 'imgmin', (env)->
    if not (env=='src' or env=='dev')
      console.log 'only support src and dev task'
      return
    ref = grunt.config.get 'ref'
    imgConf =
      task1:
        src: ref.src,
        dest: ref[env]
    grunt.config.set 'img', imgConf
    grunt.loadNpmTasks 'grunt-img'
    grunt.task.run ['img:task1']

  src:
    src: '<%=src%>'
    dest: '<%=src%>'
  dev:
    src: '<%=src%>'
    dest: '<%=dev%>'