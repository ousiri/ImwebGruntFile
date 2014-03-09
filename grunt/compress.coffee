module.exports =
  pack:
    options:
      archive: '<%=ref.pack%>archive.zip'
      mode: 'zip'
    expand: true
    cwd: '<%=ref.pack%>'
    src: ['**/*']

