module.exports =
  options:
    sassDir: '<%=ref.src%>'
  dev:
    options:
      outputStyle: 'extended'
      cssDir: '<%=ref.dev%>'
  tmp:
    options:
      noLineComments: true
      outputStyle: 'compact'
      cssDir: '<%=ref.tmp%>'
