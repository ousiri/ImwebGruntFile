module.exports = (grunt)->
  grunt.task.registerTask 'templates', (env)->
    #console.log 'real self tasks', arguments
    #console.log 'running templates', env
    env = env or 'dev'
    ref = grunt.config.get 'ref'
    #console.log grunt.config.get 'tmplInline'
    srcPath = ref.src+'/template/'
    devPath = ref[env]+'/js/template/'
    tplConfig = grunt.config.get('tmplInline') or {}
    if grunt.file.exists srcPath
      if grunt.file.exists devPath
        grunt.config.set 'clean.template', [devPath]
        grunt.task.run ['clean:template']
      hasTemplateFile = false
      grunt.file.recurse srcPath, (absPath, rootDir, subDir, filename)->
        console.log 'templates', absPath, rootDir, subDir, filename
        devName = subDir or 'default'
        devFilePath = "#{devPath}/#{devName}.js"
        #if not tplConfig[devFilePath]
        srcFilePath = "#{srcPath}/#{subDir||''}/*.html"
        if not tplConfig[env]
          tplConfig[env] = {files:{}}
        tplConfig[env].files[devFilePath] = [srcFilePath]
        hasTemplateFile = true
      console.log tplConfig
      #console.log tplConfig[env].files
      if hasTemplateFile
        grunt.task.loadNpmTasks 'grunt-imweb-tpl-complie'
        grunt.config.set 'tplComplie', tplConfig
        grunt.task.run ['tplComplie:'+env]
  {}