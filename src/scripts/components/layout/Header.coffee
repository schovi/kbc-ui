React = require 'react'

RoutesStore = require '../../stores/RoutesStore.coffee'

Link = React.createFactory(require('react-router').Link)
State = require('react-router').State

{div, nav, span, a, h1} = React.DOM

getStateFromStores = ->
  breadcrumbs: RoutesStore.getBreadcrumbs()

Header = React.createClass
  displayName: 'Header'
  mixins: [State]

  getInitialState: ->
    getStateFromStores()

  componentDidMount: ->
    RoutesStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    RoutesStore.removeChangeListener(@_onChange)

  _onChange: ->
    @setState(getStateFromStores())

  render: ->

    breadcrumbs = []
    console.log @state.breadcrumbs
    @state.breadcrumbs.forEach((link, i) ->
      if i != @state.breadcrumbs.length - 1
        link = Link to: link.link.to, params: link.link.params,
          link.title
        breadcrumbs.push link
        breadcrumbs.push(span className: 'kbc-icon-arrow-right')
      else
        link = h1 null, link.title
        breadcrumbs.push link
    , @)

    nav {className: 'navbar navbar-fixed-top kbc-navbar', role: 'navigation'},
      div {className: 'col-sm-3 col-md-2 kbc-logo'},
        Link {to: 'home'},
          span className: "kbc-icon-keboola", null
          'Connection'
      div {className: 'col-sm-9 col-md-10'},
        div {className: 'kbc-main-header kbc-header'},
          div {className: 'kbc-title'},
            breadcrumbs


module.exports = Header
