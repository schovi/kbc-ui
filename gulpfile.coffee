gulp = require 'gulp'
gutil      = require 'gulp-util'
browserify = require 'browserify'
watchify   = require 'watchify'
chalk      = require 'chalk'
source     = require 'vinyl-source-stream'
prettyTime = require 'pretty-hrtime'
path       = require 'path'
ecstatic   = require 'ecstatic'
uglify     = require 'gulp-uglify'
buffer = require 'vinyl-buffer'
browserSync = require 'browser-sync'
reload = browserSync.reload
parse = require('url').parse
fs = require 'fs'

handleError = (err) ->
  gutil.log err
  gutil.beep()
  this.emit 'end'

defaultFile = "index.html"

gulp.task 'server', ->
  browserSync
    server:
      baseDir: path.join(__dirname, 'src')
      routes:
        "/bower_components": path.join(__dirname, 'bower_components')
      # handles pushstate rewrite
      middleware: (req, res, next) ->
        fileName = parse(req.url)
        fileName = fileName.href.split(fileName.search).join("")
        fileExists = fs.existsSync(path.join(__dirname, 'src') + fileName)
        if !fileExists && fileName.indexOf("browser-sync-client") < 0 && fileName.indexOf("bower_components") < 0
          req.url = "/" + defaultFile
        next()


gulp.task 'watch', ->

  bundle = watchify browserify
    entries: ['./src/scripts/app.coffee']
    extensions: ['.coffee']
    debug: true
    cache: {}
    packageCache: {}
    fullPaths: true

  bundle.on 'update', ->
    gutil.log "Starting '#{chalk.cyan 'rebundle'}'..."
    start = process.hrtime()
    build = bundle.bundle()
    .on 'error', handleError
    .pipe source 'bundle.js'

    build
    .pipe gulp.dest 'src/scripts'
    .pipe(reload stream: true)
    gutil.log "Finished '#{chalk.cyan 'rebundle'}' after #{chalk.magenta prettyTime process.hrtime start}"

  .emit 'update'

gulp.task 'build', ->
  bundler = browserify
    entries: ['./src/scripts/app.coffee']
    extensions: ['.coffee']
    debug: true
    cache: {}
    packageCache: {}
    fullPaths: true

  bundler.bundle()
  .pipe(source('bundle.min.js'))
  .pipe(buffer())
  .pipe(uglify())
  .pipe(gulp.dest('./src/scripts'))

gulp.task 'default', ['watch', 'server']