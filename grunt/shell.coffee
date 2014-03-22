module.exports = ->
  npmInstall:
    command: 'npm install'
    options:
      stdout: true
  npmUpdate:
    command: 'npm update'
    options:
      stdout: true
  npmInstallImwebGruntFile:
    command: 'npm install imweb-gruntfile'
    options:
      stdout: true