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
    ref =  grunt.config.get 'ref'
    destPath = filePath.replace ref.src, ref.dev
    if action == 'deleted'
      if grunt.file.exists destPath
        grunt.file.delete destPath
    else
      if grunt.file.isDir filePath
        copyDir filePath, destPath
      else
        grunt.file.copy filePath, destPath
    if target == 'compass'
      grunt.task.run ['compass:dev']
    if target == 'html'
      grunt.task.run ['doUsemin:dev']
    if target == 'template'
      console.log grunt.file.read filePath
      grunt.task.run ['templates:dev']
    #if target == 'main'
    #  grunt.task.run ['concat']

  options:
    spawn: false
    cwd: '<%=ref.src%>'
  compass:
    files: ['**/*.scss']
    #tasks: ['compass:dev']
  html:
    files: ['**/*.html', '!template/**/*.html']
  template:
    files: ['template/**/*.html']
  main:
    files: ['**/*.*']
