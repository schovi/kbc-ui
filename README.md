
# Keboola Connection UI

User interface for Keboola Connection

https://s3.amazonaws.com/kbc-uis/kbc/index.html


## Development

* Clone the repo
* Instal global dependencies `npm install -g gulp bower`
* Install local dependencies `npm install && bower install --dev`
* Server, watch and test with live reload `gulp`

Application will be opened in your browser and will be reloaded after each change in source files.


## Build dist package

* `gulp build` builds app into `dist` folder
* You can test it locally `gulp dist-server`