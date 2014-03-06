module.exports = (grunt)->
  grunt.task.registerTask 'doUseminPrepare', (env)->
    env = env or 'dev'
    ref = grunt.config.get 'ref'

    useminConfig =
      options:
        dest: ref[env]
      html: ["#{if env=='dev' then ref[env] else ref['tmp']}/**/*.html"]
    console.log 'useminConfig: ', useminConfig

    grunt.task.loadNpmTasks 'casper-usemin-tmp'
    grunt.config.set 'casperUseminTmp', useminConfig
    grunt.task.run ['casperUseminTmp']

  {}
