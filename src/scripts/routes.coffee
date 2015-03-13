React = require 'react'
Router = require 'react-router'
App = require './react/layout/App'
ErrorPage = require './react/pages/ErrorPage'

componentsRoutes = require './modules/components/Routes'
orchestrationsRoutes = require './modules/orchestrations/Routes'
jobsRoutes = require './modules/jobs/Routes'
transformationsRoutes = require './modules/transformations/Routes'

CronScheduler = require './react/common/CronScheduler'

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
  getInitialState: ->
    crontabRecord: '0 0 * * 2'
  render: ->
    React.DOM.div className: 'container-fluid kbc-main-content',
      'Home'
      React.createElement CronScheduler,
        crontabRecord: @state.crontabRecord
        onChange: @_handleChange




  _handleChange: (crontabRecord) ->
    console.log 'changed', crontabRecord
    @setState
      crontabRecord: crontabRecord

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
