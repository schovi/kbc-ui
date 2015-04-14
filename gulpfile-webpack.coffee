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
map = require 'map-stream'

makeWebpackConfig = require './webpack/make-config'
WebpackDevServer = require('webpack-dev-server')
webpack = require('webpack')

env =
  devServer: {}

gulp.task 'clean', (cb) ->
  del(['dist/**', 'tmp/**', 'release/**'], cb)


gulp.task 'prepare-dev', ['clean'], ->
  gulp.src('./src/index.html')
  .pipe(gulp.dest('./tmp'))

  gulp.src('./bower_components/kbc-bootstrap/dist/fonts/**')
  .pipe(gulp.dest('./tmp/fonts'))

  gulp.src('./bower_components/kbc-bootstrap/dist/img/**')
  .pipe(gulp.dest('./tmp/images'))

  gulp.src('./src/media/**')
  .pipe(gulp.dest('./tmp/media'))


gulp.task 'less', ['clean'], ->
  gulp.src(['./src/styles/app.less', './node_modules/react-select/less/default.less'])
  .pipe(less())
  .pipe(addsrc('./node_modules/codemirror/lib/codemirror.css'))
  .pipe(addsrc('./node_modules/codemirror/theme/solarized.css'))
  .pipe(addsrc('./node_modules/typeahead/style.css'))
  .pipe(addsrc('./node_modules/react-datepicker/dist/react-datepicker.css'))
  .pipe(concat('app.css'))
  .pipe(gulp.dest('./tmp/styles'))
  .pipe(map((a, cb) ->
    #if env.devServer.invalidate? then env.devServer.invalidate()
    cb()
  ))

  gulp.src(['./src/styles/kbc.less'])
  .pipe(less())
  .pipe(gulp.dest('./tmp/styles'))
  .pipe(map((a, cb) ->
    #if env.devServer.invalidate? then env.devServer.invalidate()
    cb()
  ))

gulp.task 'default', ['less', 'prepare-dev', 'build-webpack-dev'], ->
  gulp.watch ['./src/styles/app.less', './bower_components/kbc-bootstrap/dist/**'], ['less']



gulp.task 'build-webpack-dev', (callback) ->
  config = makeWebpackConfig(true)
  env.devServer = new WebpackDevServer(webpack(config), {
    contentBase: './tmp/',
    publicPath: config.output.publicPath
    hot: true,
    historyApiFallback: true
  })

  env.devServer.listen(3000, 'localhost', (err, result) ->
    if (err)
      throw new gutil.PluginError('webpack-dev-server', err)

    console.log('Listening at localhost:3000')
    callback()
  )
