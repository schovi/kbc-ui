
# Keboola Connection UI [![Build Status](https://travis-ci.org/keboola/kbc-ui.svg?branch=master)](https://travis-ci.org/keboola/kbc-ui)

User interface for Keboola Connection


## Development

* Clone the repo
* Install dependencies `npm install`
* Server, watch and test with live reload `npm start`
* Open this url in your browser `http://localhost:3000/?token=YOUR_STORAGE_API_TOKEN`

Application will be opened in your browser and will be hot reloaded after each change in source files.

### Build dist package

* `npm run build` (It is executed by Travis after each push)

##  Application Architecture

 * Single page application running in browser data fetching from Keboola REST APIs.
 * Written in [ES2015](https://babeljs.io/docs/learn-es2015/) (ES6) compiled to JS using [Babel](https://babeljs.io/) (older parts are written in Coffeescript). 
 * Bundled by [Webpack](https://webpack.github.io/). 
 * View layer is composed by [React](http://facebook.github.io/react/) components
 * [Flux Architecture](https://facebook.github.io/flux/docs/overview.html) with unidirectional data flow controlling whole application. Vanilla Flux implementation is used.
 * [React Router](http://rackt.github.io/react-router/) for routing
 * [Keboola Bootstrap](https://github.com/keboola/kbc-bootstrap) for UI components style. It is based on [Twitter Bootstrap](http://getbootstrap.com/)

## HOW TO

### Add assets
Whole application is bundled by Webpack, not just js and coffee script files but also stylesheets (less, css), media and image files.
Assets should be loaded by `require` or `import` function.

**Examples:**

 * [CSS include](https://github.com/keboola/kbc-ui/blob/b6f8568ff3f5ac76e3c5063d6327b33ae543da24/src/scripts/react/layout/App.coffee#L18)
 * [Image](https://github.com/keboola/kbc-ui/blob/b6f8568ff3f5ac76e3c5063d6327b33ae543da24/src/scripts/react/common/JobStatusCircle.coffee#L5)
 * [mp3](https://github.com/keboola/kbc-ui/blob/b6f8568ff3f5ac76e3c5063d6327b33ae543da24/src/scripts/utils/SoundNotifications.coffee#L4)
