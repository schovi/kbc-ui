React = require 'react'
createStoreMixin = require '../../mixins/createStoreMixin.coffee'

RoutesStore = require '../../stores/RoutesStore.coffee'

Link = React.createFactory(require('react-router').Link)

{div, nav, span, a, h1} = React.DOM


Header = React.createClass
  displayName: 'Header'
  mixins: [createStoreMixin(RoutesStore)]

  getStateFromStores: ->
    breadcrumbs: RoutesStore.getBreadcrumbs()
    currentRouteConfig: RoutesStore.getCurrentRouteConfig()

  render: ->
    nav {className: 'navbar navbar-fixed-top kbc-navbar', role: 'navigation'},
      div {className: 'col-sm-3 col-md-2 kbc-logo'},
        Link {to: 'home'},
          span className: "kbc-icon-keboola", null
          'Connection'
      div {className: 'col-sm-9 col-md-10'},
        div {className: 'kbc-main-header kbc-header'},
          div {className: 'kbc-title'},
            @_renderBreadcrumbs()
            ' '
            @_renderReloader()
          div {className: 'kbc-buttons'},
            @_renderButtons()

  _renderBreadcrumbs: ->
    breadcrumbs = []
    @state.breadcrumbs.forEach((part, i) ->
      if i != @state.breadcrumbs.size - 1
        partElement = Link key: part.get('name'), to: part.getIn(['link', 'to']), params: part.getIn(['link', 'params']).toJS(),
          part.get 'title'
        breadcrumbs.push partElement
        breadcrumbs.push(span className: 'kbc-icon-arrow-right', key: 'arrow-' + part.get('name'))
      else
        partElement = h1 key: part.get('name'), part.get('title')
        breadcrumbs.push partElement
    , @)
    breadcrumbs

  _renderReloader: ->
    if !@state.currentRouteConfig?.get 'reloaderHandler'
      null
    else
      React.createElement(@state.currentRouteConfig.get 'reloaderHandler')

  _renderButtons: ->
    if !@state.currentRouteConfig?.get 'headerButtonsHandler'
      null
    else
      React.createElement(@state.currentRouteConfig.get 'headerButtonsHandler')


module.exports = Header
