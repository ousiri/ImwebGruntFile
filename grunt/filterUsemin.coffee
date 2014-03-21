module.exports = (grunt)->
  grunt.task.registerTask 'filterUsemin', (env)->
    #console.log grunt.config.get 'concat'
    concatConfig = grunt.config.get 'concat'
    for devFile, srcFiles of concatConfig
      if devFile.match /\?|#/
        realFile = devFile.replace(/\?.*$|#.*$/g, '')
        if not concatConfig[realFile]
          concatConfig[realFile] = concatConfig[devFile]
        delete concatConfig[devFile]
    console.log concatConfig
    grunt.config.set 'concat', concatConfig
    #console.log concatConfig
  {}