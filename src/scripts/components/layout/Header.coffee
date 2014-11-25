React = require 'react'
Link = React.createFactory(require('react-router').Link)
ActiveState = require('react-router').ActiveState

{div, nav, span, a, h1} = React.DOM

Header = React.createClass
  displayName: 'Header'
  mixins: [ActiveState]
  render: ->

    breadcrumbs = []

    filtered = @getActiveRoutes().filter((route) ->
      route.props.path != '/' && !route.props.isDefault
    )

    filtered.forEach((route, i) ->
      name = route.props.name
      if i != filtered.length - 1
        link = Link to: route.props.path,
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
      div {className: 'col-sm-9 col-md-10'},
        div {className: 'kbc-main-header kbc-header-with-buttons'},
          div {className: 'kbc-title kbc-header'},
            breadcrumbs


module.exports = Header
