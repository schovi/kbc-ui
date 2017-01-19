var fs = require('fs');

var revision = process.env.KBC_REVISION;
var s3basePath = "https://d38qy9k7n8xp7k.cloudfront.net/kbc/" + revision + "/";

var manifest = {
    "name": "kbc",
    "version": revision,
    basePath: s3basePath,
    "scripts": [
        s3basePath + 'bundle.min.js'
    ],
    "styles": [
        s3basePath + 'bundle.min.css'
    ]
};

console.log(manifest);

fs.writeFile("./dist/" + revision + "/manifest.json", JSON.stringify(manifest), function(err) {
   if (err) {
       throw err;
   }
});
