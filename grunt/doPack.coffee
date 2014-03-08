path = require 'path'
uglify = require 'uglify-js'
cssmin = require 'cssmin'
fs = require 'fs'

module.exports = (grunt)->
  grunt.task.registerMultiTask 'doPack', ()->
    console.log 'doPack'
    supportedTypes =
      html: 'html'
      css: 'css'
      ico: 'html'
      js: 'js'
      png: 'img'
      jpg: 'img'
      jpeg: 'img'
      gif: 'img'

    options = @options()
    paths =
      img: (options.imgCdn or options.cdn or options.htdocs).replace(/https?:\/\//, '')
      js: (options.jsCdn or options.cdn or options.htdocs).replace(/https?:\/\//, '')
      css: (options.cssCdn or options.cdn or options.htdocs).replace(/https?:\/\//, '')
      html: options.htdocs.replace(/https?:\/\//, '')
    ref = grunt.config.get 'ref'
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
    src: ['<%=ref.dist%>**/*.*']