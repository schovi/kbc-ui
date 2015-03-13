React = require 'react'
Router = require 'react-router'
App = require './react/layout/App'
ErrorPage = require './react/pages/ErrorPage'

componentsRoutes = require './modules/components/Routes'
orchestrationsRoutes = require './modules/orchestrations/Routes'
jobsRoutes = require './modules/jobs/Routes'
transformationsRoutes = require './modules/transformations/Routes'

Writers = React.createClass
  displayName: 'Writers'
  render: ->
    React.DOM.div null, 'Writers'

Home = React.createClass
  displayName: 'Home'
  render: ->
    React.DOM.div className: 'container-fluid kbc-main-content',
      'Home'

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
