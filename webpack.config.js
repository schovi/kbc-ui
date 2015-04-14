var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: [
    "webpack-dev-server/client?http://0.0.0.0:3000",
    'webpack/hot/only-dev-server',
    './src/scripts/app'
  ],
  devtool: "eval",
  debug: true,
  output: {
    path: path.join(__dirname, "tmp"),
    filename: 'bundle.js',
    publicPath: '/scripts/'
  },
  resolveLoader: {
    modulesDirectories: ['node_modules']
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new webpack.IgnorePlugin(/vertx/) // https://github.com/webpack/webpack/issues/353
  ],
  resolve: {
    extensions: ['', '.js', '.cjsx', '.coffee']
  },
  module: {
    loaders: [
      { test: /\.less$/, loader: 'style-loader!css-loader!less-loader'},
      { test: /\.json$/, loaders: ['json']},
      { test: /\.css$/, loader: 'style-loader!css-loader'},
      { test: /\.coffee$/, loaders: ['react-hot-loader', 'coffee'] }
    ]
  }
};
