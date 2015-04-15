var fs = require('fs');

var revision = process.env.KBC_REVISION;
var s3basePath = "https://kbc-uis.s3.amazonaws.com/kbc/" + revision + "/";

var manifest = {
    "name": "kbc",
    "version": revision,
    basePath: s3basePath,
    "scripts": [
        s3basePath + 'app.min.js'
    ],
    "styles": [
        s3basePath + 'app.min.css'
    ]
};

console.log(manifest);

fs.writeFile("./dist/" + revision + "/manifest.json", JSON.stringify(manifest), function(err) {
   if (err) {
       throw err;
   }
});
