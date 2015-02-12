React = require 'react'
Router = require 'react-router'
App = require './react/layout/App.coffee'
ErrorPage = require './react/pages/ErrorPage.coffee'

componentsRoutes = require './modules/components/Routes.coffee'
orchestrationsRoutes = require './modules/orchestrations/Routes.coffee'
jobsRoutes = require './modules/jobs/Routes.coffee'
transformationsRoutes = require './modules/transformations/Routes.coffee'

Transformations = React.createClass
  displayName: 'Transformations'
  render: ->
    React.DOM.div className: 'container-fluid kbc-main-content', 'Transformations'


Writers = React.createClass
  displayName: 'Writers'
  render: ->
    React.DOM.div null, 'Writers'

Home = React.createClass
  displayName: 'Home'
  render: ->
    React.DOM.div className: 'container-fluid kbc-main-content', 'Home'

NotFound = React.createClass
  displayName: 'NotFound'
  render: ->
    React.DOM.div className: 'container-fluid kbc-main-content', 'Page not found'


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
      orchestrationsRoutes
    ,
      componentsRoutes.extractors
    ,
      componentsRoutes.writers
    ,
      jobsRoutes
    ,
      transformationsRoutes

  ]



module.exports = routes
