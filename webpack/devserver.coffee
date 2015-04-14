webpack = require('webpack')
WebpackDevServer = require('webpack-dev-server')
gutil = require('gulp-util')

module.exports = (webpackConfig) ->
  (callback) ->
    new WebpackDevServer(webpack(webpackConfig), {
      contentBase: './tmp/',
      hot: true,
      historyApiFallback: true
    }).listen(3000, 'localhost', (err, result) ->
      if (err)
        throw new gutil.PluginError('webpack-dev-server', err)

      console.log('Listening at localhost:3000')
      callback()
    )
