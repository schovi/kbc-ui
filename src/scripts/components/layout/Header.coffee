React = require 'react'
Link = React.createFactory(require('react-router').Link)
State = require('react-router').State

{div, nav, span, a, h1} = React.DOM

Header = React.createClass
  displayName: 'Header'
  mixins: [State]
  render: ->

    breadcrumbs = []
    currentParams = @getParams()

    filtered = @getRoutes().filter((route) ->
      route.path != '/' && !route.isDefault
    )

    filtered.forEach((route, i) ->
      name = route.name
      if i != filtered.length - 1
        link = Link to: route.path, params: currentParams,
          name
        breadcrumbs.push link
        breadcrumbs.push(span className: 'kbc-icon-arrow-right')
      else
        link = h1 null, name
        breadcrumbs.push link
    )

    nav {className: 'navbar navbar-fixed-top kbc-navbar', role: 'navigation'},
      div {className: 'col-sm-3 col-md-2 kbc-logo'},
        Link {to: 'home'},
          span className: "kbc-icon-keboola", null
          'Connection'
      div {className: 'col-sm-9 col-md-10 kbc-main-header'},
        div {className: 'kbc-title'},
          breadcrumbs


module.exports = Header
