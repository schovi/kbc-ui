React = require 'react'
App = React.createFactory(require('./components/App.coffee'))

React.render(App(), document.getElementById 'react')