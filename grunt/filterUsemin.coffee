module.exports = (grunt)->
  grunt.task.registerTask 'filterUsemin', (env)->
    #console.log grunt.config.get 'concat'
    concatConfig = grunt.config.get 'concat'
    for devFile, srcFiles of concatConfig
      if devFile.match /\?|#/
        concatConfig[devFile.replace(/\?.*$|#.*$/g, '')] = concatConfig[devFile]
        delete concatConfig[devFile]
    grunt.config.set 'concat', concatConfig
    #console.log concatConfig
  {}