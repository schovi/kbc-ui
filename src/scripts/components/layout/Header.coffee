React = require 'react'
Link = React.createFactory(require('react-router').Link)

{div, nav, span, a, h1} = React.DOM

Header = React.createClass
  displayName: 'Header'
  render: ->
    nav {className: 'navbar navbar-fixed-top kbc-navbar', role: 'navigation'},
      div {className: 'col-sm-3 col-md-2 kbc-logo'},
        Link {to: 'home'},
          span className: "kbc-icon-keboola", null
          'Connection'
      div {className: 'col-sm-9 col-md-10 kbc-main-header'},
        div {className: 'kbc-title'},
          a null, 'Extractors'
          span className: 'kbc-icon-arrow-right'
          h1 null, 'New Extractor'



module.exports = Header
