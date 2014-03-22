module.exports =
  dev:
    files: [{
      expand: true,
      cwd: '<%=ref.src%>'
      src: [
        '**/*.{jpg,jpeg,bmp,png,gif,ico}'
      ]
      dest: '<%=ref.dev%>'
    }, {
      expand: true,
      cwd: '<%=ref.src%>'
      src: ['**/*.html', '!template/**/*.html', '!inline/**/*.html']
      dest: '<%=ref.dev%>'
    }, {
      expand: true,
      cwd: '<%=ref.src%>'
      src: [
        '**/*.{js,css}'
      ]
      dest: '<%=ref.dev%>'
    }]
  tmp:
    files: [{
      expand: true,
      cwd: '<%=ref.src%>'
      src: [
        '**/*.{jpg,jpeg,bmp,png,gif,ico}'
      ]
      dest: '<%=ref.tmp%>'
    }, {
      expand: true,
      cwd: '<%=ref.src%>'
      src: ['**/*.html', '!template/**/*.html']
      dest: '<%=ref.tmp%>'
    }, {
      expand: true,
      cwd: '<%=ref.src%>'
      src: [
        '**/*.{js,css}'
      ]
      dest: '<%=ref.tmp%>'
    }]
  dist:
    files: [{
      expand: true,
      cwd: '<%=ref.tmp%>'
      src: [
        '**/*.{jpg,jpeg,bmp,png,gif,ico}'
      ]
      dest: '<%=ref.dist%>'
    }, {
      expand: true,
      cwd: '<%=ref.tmp%>'
      src: ['**/*.html', '!template/**/*.html', '!inline/**/*.html']
      dest: '<%=ref.dist%>'
    }]
  update:
    files: [{
      src: ['node_modules/imweb-gruntfile/grunt/*.*']
      dest: 'grunt/'
      flatten: true
    }, {
      src: ['node_modules/imweb-gruntfile/gruntfile.coffee']
      dest: 'gruntfile.coffee'
    }, {
      src: ['node_modules/imweb-gruntfile/package2.json']
      dest: 'package.json'
    }]