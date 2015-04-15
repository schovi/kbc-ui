var path = require("path");
var webpack = require("webpack");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = function (options) {
    return {
        devtool: 'eval',
        entry: [
            'webpack-dev-server/client?http://localhost:3000',
            'webpack/hot/only-dev-server',
            './src/styles/kbc.less',
            './src/scripts/app'
        ],
        output: {
            path: path.join(__dirname, 'build'),
            filename: 'bundle.js',
            publicPath: '/scripts/'
        },
        plugins: [
            new webpack.NoErrorsPlugin()
        ],
        resolve: {
            extensions: ['', '.js', '.jsx', '.coffee']
        },
        module: {
            loaders: [
                {
                    test: /\.jsx?$/,
                    loaders: ['react-hot', 'babel'],
                    include: path.join(__dirname, 'scripts')
                },
                {
                    test: /\.coffee$/,
                    loaders: ['react-hot', 'coffee']
                },
                {
                    test: /\.less$/,
                    loader: "style-loader!css-loader!less-loader"
                },
                {
                    loader: 'file-loader',
                    test: /.(png|woff|woff2|eot|ttf|svg|jpg)/
                },
                {
                    test: /\.json$/,
                    loader: 'json-loader'
                }

            ]
        }
    };

};
