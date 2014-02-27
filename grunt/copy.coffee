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