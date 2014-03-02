path = require 'path'

module.exports = (grunt)->
  ref =
    src: 'src/'
    dev: 'dev/'
    dist: 'dist/'
    tmp: '.tmp/'
  tmplInline =
    options:
      namespace: 'JST'
      processName: (filename)->
        path.basename filename, '.html'


  require('time-grunt')(grunt)
  require('load-grunt-config')(grunt, {
    config: {
      ref: ref,
      tmplInline: tmplInline
    }
  })