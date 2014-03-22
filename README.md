It's an another GruntFile...

### To use image min

For Mac

```brew install optipng jpeg```

For linux

```apt-get install opting libjpeg libjpeg-progs```

### Commands
- dev
- dist
- pack
- imgmin:dev or imgmin:src
- smushit:dev or smushit:src

### Project Configure

if you want to load multiple js file in one function, such as

```js
$.http.loadScript(['js/A.min.js', 'js/B.min.js'])
```

you can set **loadJsReg** in proj-conf.json as
```"\\$\\.http\\.loadScript\\(\\[([^\\]]+)\\]"```