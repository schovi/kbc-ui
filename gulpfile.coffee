gulp = require 'gulp'
gutil      = require 'gulp-util'
del = require 'del'
size = require 'gulp-size'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
coffeelint = require 'gulp-coffeelint'
watchify   = require 'watchify'
envify = require 'envify/custom'
chalk      = require 'chalk'
source     = require 'vinyl-source-stream'
prettyTime = require 'pretty-hrtime'
merge = require 'merge-stream'
path       = require 'path'
ecstatic   = require 'ecstatic'
rename = require 'gulp-rename'
uglify     = require 'gulp-uglify'
debug = require 'gulp-debug'
git = require 'gulp-git'
buffer = require 'vinyl-buffer'
less = require 'gulp-less'
browserSync = require 'browser-sync'
reload = browserSync.reload
parse = require('url').parse
fs = require 'fs'
sourcemaps = require 'gulp-sourcemaps'
insert = require 'gulp-insert'
concat = require 'gulp-concat'
transform = require 'vinyl-transform'
addsrc = require 'gulp-add-src'

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
        "/images": path.join(__dirname, 'bower_components/kbc-bootstrap/dist/img')
      # handles pushstate rewrite
      middleware: (req, res, next) ->
        fileName = parse(req.url)
        fileName = fileName.href.split(fileName.search).join("")
        fileExists = fs.existsSync(path.join(__dirname, 'src') + fileName) || fileExists = fs.existsSync(path.join(__dirname, 'tmp') + fileName)
        if !fileExists && fileName.indexOf("browser-sync-client") < 0 && fileName.indexOf("bower_components") < 0 && fileName.indexOf("fonts") < 0 && fileName.indexOf("images") < 0
          req.url = "/" + defaultFile
        next()

gulp.task 'dist-server', ->
  browserSync
    server:
      baseDir: './dist'

gulp.task 'clean', (cb) ->
  del(['dist/**', 'tmp/**', 'release/**'], cb)

gulp.task 'watch', ->

  bundle = watchify browserify
    entries: ['./src/scripts/app.coffee']
    extensions: ['.coffee']
    debug: true
    cache: {}
    packageCache: {}
    fullPaths: true

  bundle.transform(coffeeify)
  bundle.transform(envify(NODE_ENV: 'development'))

  bundle.on 'update', (changedFiles) ->
    gutil.log "Starting '#{chalk.cyan 'rebundle'}'..."
    start = process.hrtime()

    build = bundle.bundle()
    .on 'error', handleError
    .pipe source 'bundle.js'
    .pipe gulp.dest 'tmp/scripts'
    .pipe(reload stream: true)
    gutil.log "Finished '#{chalk.cyan 'rebundle'}' after #{chalk.magenta prettyTime process.hrtime start}"

    if changedFiles
      lintStream = gulp.src(changedFiles)
      .pipe(coffeelint('./coffeelint.json'))
      .pipe(coffeelint.reporter())

      return merge(lintStream, build)
    else
      return build

  .emit 'update'

  gulp.watch ['./src/styles/app.less', './bower_components/kbc-bootstrap/dist/**'], ['less']

gulp.task 'less', ['clean'], ->
  gulp.src(['./src/styles/app.less', './node_modules/react-select/less/default.less'])
  .pipe(less())
  .pipe(addsrc('./node_modules/codemirror/lib/codemirror.css'))
  .pipe(addsrc('./node_modules/codemirror/theme/solarized.css'))
  .pipe(addsrc('./node_modules/typeahead/style.css'))
  .pipe(addsrc('./node_modules/react-datepicker/dist/react-datepicker.css'))
  .pipe(concat('app.css'))
  .pipe(gulp.dest('./tmp/styles'))
  .pipe(browserSync.reload( stream:true))

  gulp.src(['./src/styles/kbc.less'])
  .pipe(less())
  .pipe(gulp.dest('./tmp/styles'))
  .pipe(browserSync.reload( stream:true))

gulp.task 'build-styles', ['clean'], ->
  gulp.src(['./src/styles/app.less', './node_modules/react-select/less/default.less'])
    .pipe(less())
    .pipe(addsrc('./node_modules/codemirror/lib/codemirror.css'))
    .pipe(addsrc('./node_modules/codemirror/theme/solarized.css'))
    .pipe(addsrc('./node_modules/typeahead/style.css'))
    .pipe(addsrc('./node_modules/react-datepicker/dist/react-datepicker.css'))
    .pipe(concat('app.css'))
    .pipe(rename('app.min.css'))
    .pipe(gulp.dest('./dist/styles'))

gulp.task 'copy', ['clean'], ->
  gulp.src('./bower_components/kbc-bootstrap/dist/fonts/**')
  .pipe(gulp.dest('./dist/fonts'))

  gulp.src('./bower_components/kbc-bootstrap/dist/img/**')
  .pipe(gulp.dest('./dist/images'))

  gulp.src('./src/media/**')
  .pipe(gulp.dest('./dist/media'))

  gulp.src('./src/index.dist.html')
  .pipe(rename('index.html'))
  .pipe(gulp.dest('./dist'))

gulp.task 'lint', ->
  gulp.src(['./src/**/*.coffee', '!./src/scripts/__fixtures/martin.coffee'])
  .pipe coffeelint('./coffeelint.json')
  .pipe coffeelint.reporter()
  .pipe coffeelint.reporter('fail')


gulp.task 'build-scripts', ['clean'], ->

  browserified = transform (fileName) ->
    b = browserify
      entries: [fileName]
      extensions: ['.coffee']
      debug: true
      fullPaths: false
    b.transform(coffeeify)
    b.transform(envify(NODE_ENV: 'production'))
    b.bundle()

  gulp.src('./src/scripts/app.coffee')
  .pipe(browserified)
  .pipe(sourcemaps.init(loadMaps: true))
  .pipe(uglify())
  .pipe(rename('bundle.min.js'))
  .pipe(sourcemaps.write('./'))
  .pipe(size(showFiles: true, gzip: false))
  .pipe(size(showFiles: true, gzip: true))
  .pipe(gulp.dest('./dist/scripts'))


tag = ''
gulp.task 'read-revision', (cb) ->
  git.exec args : 'describe --tags', (err, newTag) ->
    throw err if err
    tag = newTag.trim()
    console.log 'revision: ' + tag
    cb()

gulp.task 'copy-to-release', ['build', 'read-revision'], ->
  gulp.src('./dist/**')
  .pipe(gulp.dest("./release/#{tag}"))

gulp.task 'build', [ 'lint', 'build-styles', 'build-scripts', 'copy']

gulp.task 'default', ['less', 'watch', 'server']

gulp.task 'release', ['copy-to-release'], ->

  s3basePath = "https://kbc-uis.s3.amazonaws.com/"
  s3basePath = s3basePath + "kbc/#{tag}/"

  manifest =
    name: 'kbc'
    version: tag
    basePath: s3basePath
    buildUrl: 'https://travis-ci.org/' + process.env.TRAVIS_REPO_SLUG + '/builds/' + process.env.TRAVIS_BUILD_ID
    scripts: [
      s3basePath + 'scripts/bundle.min.js'
    ]
    styles: [
      s3basePath + 'styles/app.min.css'
    ]

  console.log 'Manifest URL: ', "#{s3basePath}manifest.json"
  fs.writeFile "./release/#{tag}/manifest.json", JSON.stringify(manifest), (err) ->
    throw err if err
