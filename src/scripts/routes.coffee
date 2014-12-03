React = require 'react'
Router = require 'react-router'
App = require './components/App.coffee'

componentsRoutes = require './modules/components/routes.coffee'
orchestrationsRoutes = require './modules/orchestrations/routes.coffee'

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


# Custom routing configuration object
routes =
  handler: App
  path: '/'
  title: 'Home'
  defaultRouteHandler: Home
  defaultRouteName: 'home'
  notFoundRouteHandler: NotFound
  childRoutes: [
      name: 'transformations'
      title: 'Transformations'
      handler: Transformations
    ,
      orchestrationsRoutes
    ,
      componentsRoutes.extractors
    ,
      componentsRoutes.writers
    ,
      name: 'storage'
      title: 'Storage'
      handler: Storage
  ]



module.exports = routes