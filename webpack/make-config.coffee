path = require('path')
webpack = require('webpack')

module.exports = (isDevelopment) ->
  config =
    entry: [
      "webpack-dev-server/client?http://0.0.0.0:3000",
      'webpack/hot/only-dev-server',
      './src/scripts/app'
    ],
    devtool: "eval",
    debug: true,
    output: {
      path: path.join(__dirname, "tmp"),
      publicPath: '/scripts/',
      filename: 'bundle.js'
    },
    resolveLoader: {
      modulesDirectories: ['node_modules']
    },
    plugins: [
      new webpack.HotModuleReplacementPlugin(),
      new webpack.NoErrorsPlugin()
    ],
    resolve: {
      extensions: ['', '.js', '.cjsx', '.coffee']
    },
    module: {
      loaders: [
        { test: /\.json$/, loaders: ['json']},
        { test: /\.coffee$/, loaders: ['react-hot-loader', 'coffee'] }
      ]
    }
