React = require 'react'
RouteHandler = React.createFactory(require('react-router').RouteHandler)

Header = React.createFactory(require './layout/Header.coffee')
Sidebar = React.createFactory(require './layout/Sidebar.coffee')

{div} = React.DOM

App = React.createClass
  displayName: 'App'
  render: ->
    React.DOM.div null,
      Header(),
      div className: 'container-fluid',
        div className: 'row',
          div className: 'col-sm-3 col-md-2 kbc-sidebar',
            Sidebar()
          div className: 'col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 kbc-main',
            RouteHandler()


module.exports = App