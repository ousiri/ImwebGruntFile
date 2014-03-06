module.exports =
  dist:
    options:
      relativeTo: '<%=ref.tmp%>'
      cssmin: true
      uglify: true
    src: ['<%=ref.dist%>**/*.html']
