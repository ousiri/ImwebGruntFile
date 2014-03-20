path = require 'path'
uglify = require 'uglify-js'
cssmin = require 'cssmin'
fs = require 'fs'

module.exports = (grunt)->
  grunt.task.registerMultiTask 'doPack', ()->
    #console.log 'doPack'
    options = @options()
    ref = grunt.config.get 'ref'
    cdnConfig = grunt.config.get 'cdn.dist.options'

    supportedTypes =
      html: 'html'
      css: 'css'
      ico: 'html'
      js: 'js'
      png: 'img'
      jpg: 'img'
      jpeg: 'img'
      gif: 'img'

    paths =
      img: (cdnConfig.img or cdnConfig.cdn or ref.htdocs).replace(/https?:\/\//, '')
      js: (cdnConfig.js or cdnConfig.cdn or ref.htdocs).replace(/https?:\/\//, '')
      css: (cdnConfig.css or cdnConfig.cdn or ref.htdocs).replace(/https?:\/\//, '')
      html: ref.htdocs.replace(/https?:\/\//, '')
    @filesSrc.forEach (filePath)->
      #console.log filePath
      type = path.extname(filePath).replace /^./, ''
      if not supportedTypes[type]
        return
      targetPath = path.join ref.pack, paths[supportedTypes[type]], path.relative(options.parentDir, filePath)
      if supportedTypes[type]=='js'
        grunt.file.write targetPath, uglify.minify(filePath).code, {encoding:'utf8'}
      else if supportedTypes[type]=='css'
        grunt.file.write targetPath, cssmin(fs.readFileSync(filePath).toString()), {encoding:'utf8'}
      else
        grunt.file.copy filePath, targetPath

  pack:
    options:
      cdn: 'http://test.cdn.com/test/'
      imgCdn: 'http://3.cdn.com/test/'
      jsCdn: 'http://1.cdn.com/test/'
      cssCdn: 'http://2.cdn.com/test/'
      htdocs: 'http://www.qq.com/'
      parentDir: '<%=ref.dist%>'
    expand: true,
    cwd: '<%=ref.dist%>'
    src: ['**/*.*']