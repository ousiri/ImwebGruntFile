module.exports = (grunt)->
  copyDir = (src, dest)->
    if not grunt.file.exists src
      console.log 'from copyDir:', src, 'is not exists'
      return
    if not grunt.file.exists dest
      grunt.file.mkdir dest

    grunt.file.recurse src, (absPath, rootDir, subDir, fileName)->
      console.log 'grunt.file.recurse ', arguments
      grunt.file.copy absPath, absPath.replace(src, dest)

  grunt.event.on 'watch', (action, filePath, target)->
    # only consider dev
    console.log 'from watch event', action, filePath, target
    #if target == 'compass'
      #return
    #destPath = '<%=ref.dev%>'
    if target == 'compass'
      grunt.task.run ['compass:dev']
    if target == 'template'
      grunt.task.run ['templates:dev']
    if target == 'html' or target == 'static'
      ref =  grunt.config.get 'ref'
      destPath = filePath.replace('\\', '/').replace ref.src, ref.dev
      console.log 'watch event', filePath, destPath, ref, filePath
      if action == 'deleted'
        if grunt.file.exists destPath
          grunt.file.delete destPath
      else
        if grunt.file.isDir filePath
          copyDir filePath, destPath
        else
          grunt.file.copy filePath, destPath
    if target == 'html'
      grunt.task.run ['doUseminPrepare:dev']
    grunt.task.run ['concat']

  options:
    spawn: false
    cwd: '<%=ref.src%>'
  compass:
    files: ['**/*.scss']
    #tasks: ['compass:dev']
  html:
    files: ['**/*.html', '!template/**/*.html']
  static:
    files: ['**/*.{js,css,jpg,jpeg,bmp,png,gif,ico}']
  template:
    files: ['template/**/*.html']
  #main:
  #  files: ['**/*.*']
