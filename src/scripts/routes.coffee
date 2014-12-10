React = require 'react'
Router = require 'react-router'
App = require './components/App.coffee'
ErrorPage = require './components/ErrorPage.coffee'

componentsRoutes = require './modules/components/Routes.coffee'
orchestrationsRoutes = require './modules/orchestrations/Routes.coffee'
jobsRoutes = require './modules/jobs/Routes.coffee'

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
  title: 'Overview'
  name: 'app'
  defaultRouteHandler: Home
  defaultRouteName: 'home'
  notFoundRouteHandler: ErrorPage
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
    ,
      jobsRoutes

  ]



module.exports = routes
