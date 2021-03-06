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
    pack: 'pack/'
    htdocs: finishWith conf.htdocs, '/'
  tmplInline =
    options:
      namespace: conf.tmplInlineNamespace or 'JST'
      processName: (filename)->
        path.basename filename, '.html'
  cdnRoot =
    img: finishWith "#{conf.cdnRoot.img or ''}#{conf.path or ''}", '/'
    css: finishWith "#{conf.cdnRoot.css or ''}#{conf.path or ''}/", '/'
    js: finishWith "#{conf.cdnRoot.js or ''}#{conf.path or ''}/", '/'
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
      doPack:
        pack:
          src: conf.packSrc
      regs:
        loadJs: if conf.loadJsReg then new RegExp(conf.loadJsReg, "g") else /\$\.http\.loadScript\(([^)]+)\)/g
        loadCss: if conf.loadJsReg then new RegExp(conf.loadCssReg, "g") else /\$\.http\.loadCss\(([^)]+)\)/g
        extract: /['"]([^'"]+)['"]/g # deep extraction for multiple file reference
        html: /<(?:img|link|script)[^>]*\s(?:href|src)=['"]([^'"]+)['"][^>]*\/?>/ig # find reference for html
        css: /:\s*url\(['"]?([^'")]+)['"]?\)/ig # find css reference
        abs: /\+|\<%|^https?:\/\/|^\/\/|^data:/ig # absolute url
        skip: /\+|<%/g # prevent template render replacement
        params: /(?:\?|#).*$/ # get and hash params
      disabledFeatures: conf.disabledFeatures or []
    }
  })