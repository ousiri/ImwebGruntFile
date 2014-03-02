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
      src: ['**/*.html', '!template/**/*.html']
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
      src: ['**/*.html', '!template/**/*.html']
      dest: '<%=ref.dist%>'
    }]
