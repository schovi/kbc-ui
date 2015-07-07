
# Keboola Connection UI [![Build Status](https://travis-ci.org/keboola/kbc-ui.svg?branch=master)](https://travis-ci.org/keboola/kbc-ui)

User interface for Keboola Connection


## Development

* Clone the repo
* Install dependencies `npm install`
* Server, watch and test with live reload `npm start`
* Open this url in your browser `http://localhost:3000/?token=YOUR_STORAGE_API_TOKEN`

Application will be opened in your browser and will be hot reloaded after each change in source files.

## Build dist package

* `npm run build` (It is executed by Travis after each push)


## HOW TO

### Add assets
Whole application is bundled by Webpack, not just js and coffee script files but also stylesheets (less, css), media and image files.
Assets should be loaded by `require` or `import` function.

**Examples:**

 * [CSS include](https://github.com/keboola/kbc-ui/blob/b6f8568ff3f5ac76e3c5063d6327b33ae543da24/src/scripts/react/layout/App.coffee#L18)
 * [Image](https://github.com/keboola/kbc-ui/blob/b6f8568ff3f5ac76e3c5063d6327b33ae543da24/src/scripts/react/common/JobStatusCircle.coffee#L5)
 * [mp3](https://github.com/keboola/kbc-ui/blob/b6f8568ff3f5ac76e3c5063d6327b33ae543da24/src/scripts/utils/SoundNotifications.coffee#L4)
