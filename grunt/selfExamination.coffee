module.exports = (grunt)->
  grunt.task.registerTask 'selfExamination', (env)->
    concatConfig = grunt.config.get 'concat'
    alerted = []
    for key, files of concatConfig
      files.forEach (fn)->
        if concatConfig[fn]
          if alerted.indexOf(fn)==-1
            grunt.fail.warn "alerted: #{fn} is concated by #{concatConfig[fn]}"
            alerted.push fn

  {}