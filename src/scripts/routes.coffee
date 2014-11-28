React = require 'react'
Router = require 'react-router'
App = require './components/App.coffee'

OrchestrationsIndex = require './components/orchestrations/OrchestrationsIndex.coffee'
OrchestrationDetail = require './components/orchestrations/OrchestrationDetail.coffee'
OrchestrationJobDetail = require './components/orchestrations/OrchestrationJobDetail.coffee'

RouteHandler = React.createFactory(require('react-router').RouteHandler)

# class factories parametrized by component type
createComponentsIndex = require './components/components/ComponentsIndex.coffee'
createNewComponentPage = require './components/components/NewComponent.coffee'


Route = React.createFactory(Router.Route)
DefaultRoute = React.createFactory(Router.DefaultRoute)
NotFoundRoute = React.createFactory(Router.NotFoundRoute)

Transformations = React.createClass
  displayName: 'Transformations'
  render: ->
    React.DOM.div className: 'container-fluid', 'Transformations'


Writers = React.createClass
  displayName: 'Writers'
  render: ->
    React.DOM.div null, 'Writers'

Home = React.createClass
  displayName: 'Home'
  render: ->
    React.DOM.div className: 'container-fluid', 'Home'

Storage = React.createClass
  displayName: 'Storage'
  render: ->
    React.DOM.div className: 'container-fluid', 'Storage'

NotFound = React.createClass
  displayName: 'NotFound'
  render: ->
    React.DOM.div className: 'container-fluid', 'Page not found'

Dummy = React.createClass
  displayName: 'DummyWrapper'
  render: ->
    RouteHandler()

# Routing configuration
routes =
  handler: App
  path: '/'
  defaultRouteHandler: Home
  defaultRouteName: 'home'
  notFoundRouteHandler: NotFound
  childRoutes: [
      name: 'transformations'
      handler: Transformations
    ,
      name: 'orchestrations'
      defaultRouteHandler: OrchestrationsIndex
      childRoutes: [
        name: 'orchestration'
        path: ':orchestrationId'
        defaultRouteHandler: OrchestrationDetail
        childRoutes: [
          name:  'orchestrationJob'
          path: 'jobs/:jobId'
          handler: OrchestrationJobDetail
        ]
      ]
    ,
      name: 'extractors'
      defaultRouteHandler: createComponentsIndex('extractor')
      childRoutes: [
        name: 'new-extractor'
        handler: createNewComponentPage('extractor')
      ]
    ,
      name: 'writers'
      defaultRouteHandler: createComponentsIndex('writer')
      childRoutes: [
        name: 'new-writer'
        handler: createNewComponentPage('writer')
      ]
    ,
      name: 'storage'
      handler: Storage
  ]


createReactRouterRoutes = (route) ->
  handler = route.handler || Dummy

  childRoutes = []

  if route.defaultRouteHandler
    childRoutes.push(DefaultRoute handler: route.defaultRouteHandler, name: route.defaultRouteName)

  if route.notFoundRouteHandler
    childRoutes.push(NotFoundRoute handler: route.notFoundRouteHandler)

  if route.childRoutes
    route.childRoutes.forEach((childRoute) ->
      childRoutes.push(createReactRouterRoutes(childRoute))
    )

  Route {handler: handler, name: route.name, path: route.path}, childRoutes


module.exports = createReactRouterRoutes(routes)