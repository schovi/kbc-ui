gulp = require 'gulp'
gutil      = require 'gulp-util'
clean = require 'gulp-clean'
browserify = require 'browserify'
watchify   = require 'watchify'
chalk      = require 'chalk'
source     = require 'vinyl-source-stream'
prettyTime = require 'pretty-hrtime'
path       = require 'path'
ecstatic   = require 'ecstatic'
rename = require 'gulp-rename'
uglify     = require 'gulp-uglify'
debug = require 'gulp-debug'
buffer = require 'vinyl-buffer'
less = require 'gulp-less'
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
      baseDir: [path.join(__dirname, 'src'), path.join(__dirname, 'tmp')]
      routes:
        "/bower_components": path.join(__dirname, 'bower_components')
        "/fonts": path.join(__dirname, 'bower_components/kbc-bootstrap/dist/fonts')
      # handles pushstate rewrite
      middleware: (req, res, next) ->
        fileName = parse(req.url)
        fileName = fileName.href.split(fileName.search).join("")
        fileExists = fs.existsSync(path.join(__dirname, 'src') + fileName) || fileExists = fs.existsSync(path.join(__dirname, 'tmp') + fileName)
        if !fileExists && fileName.indexOf("browser-sync-client") < 0 && fileName.indexOf("bower_components") < 0 && fileName.indexOf("fonts") < 0
          req.url = "/" + defaultFile
        next()

gulp.task 'dist-server', ->
  browserSync
    server:
      baseDir: './dist'

gulp.task 'clean', ->
  gulp.src(['./dist', './tmp'], {read: false})
  .pipe(clean())

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
    .pipe gulp.dest 'tmp/scripts'
    .pipe(reload stream: true)
    gutil.log "Finished '#{chalk.cyan 'rebundle'}' after #{chalk.magenta prettyTime process.hrtime start}"

  .emit 'update'

gulp.task 'less', ->
  gulp.src('./src/styles/app.less')
  .pipe(less())
  .pipe(gulp.dest('./tmp/styles'))

gulp.task 'build-styles', ->
  gulp.src('./src/styles/app.less')
    .pipe(less())
    .pipe(rename('app.min.css'))
    .pipe(gulp.dest('./dist/styles'))


gulp.task 'copy', ->
  gulp.src('./bower_components/kbc-bootstrap/dist/fonts/**')
  .pipe(gulp.dest('./dist/fonts'))

  gulp.src('./src/index.dist.html')
  .pipe(rename('index.html'))
  .pipe(gulp.dest('./dist'))

gulp.task 'build-scripts', ->
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
  .pipe(gulp.dest('./dist/scripts'))


gulp.task 'build', ['clean', 'build-styles', 'build-scripts', 'copy']

gulp.task 'default', ['clean', 'less', 'watch', 'server']