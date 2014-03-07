path = require 'path'



module.exports = (grunt)->
  #projConf = grunt.file.readJSON 'proj-conf.json'
  getJSON = (filePath)->
    if grunt.file.exists filePath
      content = grunt.file.read filePath
      eval "(#{content})"
    else
      {}

  finishWith = (str, sig) ->
    if str.indexOf(sig, str.length-sig.length)==-1
      str + sig
    else str

  conf = getJSON 'proj-conf.json'
  ref =
    src: conf.src or 'src/'
    dev: 'dev/'
    dist: 'dist/'
    tmp: '.tmp/'
  tmplInline =
    options:
      namespace: conf.tmplInlineNamespace or 'JST'
      processName: (filename)->
        path.basename filename, '.html'
  cdnRoot =
    imgCdn: finishWith "#{conf.cdnRoot.img or ''}#{conf.path or ''}", '/'
    cssCdn: finishWith "#{conf.cdnRoot.img or ''}#{conf.path or ''}/", '/'
    jsCdn: finishWith "#{conf.cdnRoot.img or ''}#{conf.path or ''}/", '/'
  #console.log cdn
  require('time-grunt')(grunt)
  require('load-grunt-config')(grunt, {
    config: {
      ref: ref,
      tmplInline: tmplInline
      #cdnRoot: cdnRoot
      cdn:
        dist:
          options:
            cdnRoot
    }
  })