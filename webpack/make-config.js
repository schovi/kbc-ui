var path = require("path");
var webpack = require("webpack");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = function (options) {
    var isDevelopment = options.isDevelopment;

    var plugins = [
        new webpack.DefinePlugin({
            'process.env': {
                NODE_ENV: JSON.stringify(isDevelopment ? 'development' :
                    'production'),
                IS_BROWSER: true
            }
        })
    ];

    if (isDevelopment) {
        plugins.push(new webpack.NoErrorsPlugin());
    } else {
        plugins.push(
            new webpack.PrefetchPlugin("react"),
            new webpack.PrefetchPlugin("react/lib/ReactComponentBrowserEnvironment"),
            new ExtractTextPlugin('bundle.min.css', {
                allChunks: true
            }),
            new webpack.optimize.UglifyJsPlugin(),
            new webpack.optimize.DedupePlugin()
        );
    }

    var entry = [];
    if (isDevelopment) {
        entry = [
            'webpack-dev-server/client?http://localhost:3000',
            'webpack/hot/only-dev-server',
            './src/styles/kbc.less',
            './src/scripts/app'
        ];
    }  else {
        entry = ['./src/scripts/app'];
    }


    return {
        devtool: isDevelopment ? 'eval' : '',
        entry: entry,
        output: {
            path: isDevelopment ? './dist' : './dist/' + process.env.KBC_REVISION,
            filename: isDevelopment ? 'bundle.js' : 'bundle.min.js',
            publicPath: isDevelopment ? '/scripts/' : ''
        },
        plugins: plugins,
        resolve: {
            extensions: ['', '.js', '.jsx', '.coffee']
        },
        module: {
            loaders: [
                {
                    test: /\.jsx?$/,
                    loaders: isDevelopment ? ['react-hot', 'babel'] : ['babel'],
                    include: path.join(__dirname, 'scripts')
                },
                {
                    test: /\.coffee$/,
                    loaders: isDevelopment ? ['react-hot', 'coffee'] : ['coffee']
                },
                {
                    test: /\.less$/,
                    loader: isDevelopment ? "style-loader!css-loader!less-loader" :  ExtractTextPlugin.extract("style-loader", "css-loader!less-loader")
                },
                {
                    loader: 'file-loader',
                    test: /.(png|woff|woff2|eot|ttf|svg|jpg|mp3)/
                },
                {
                    test: /\.json$/,
                    loader: 'json-loader'
                }

            ]
        }
    };

};
