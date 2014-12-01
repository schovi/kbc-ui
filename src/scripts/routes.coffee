React = require 'react'
Router = require 'react-router'
App = require './components/App.coffee'

OrchestrationsIndex = require './components/orchestrations/OrchestrationsIndex.coffee'
OrchestrationDetail = require './components/orchestrations/OrchestrationDetail.coffee'
OrchestrationJobDetail = require './components/orchestrations/OrchestrationJobDetail.coffee'


# class factories parametrized by component type
createComponentsIndex = require './components/components/ComponentsIndex.coffee'
createNewComponentPage = require './components/components/NewComponent.coffee'


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
      name: 'orchestrations'
      title: 'Orchestrations'
      defaultRouteHandler: OrchestrationsIndex
      childRoutes: [
        name: 'orchestration'
        path: ':orchestrationId'
        title: 'Orchestration'
        defaultRouteHandler: OrchestrationDetail
        childRoutes: [
          name:  'orchestrationJob'
          title: 'Job'
          path: 'jobs/:jobId'
          handler: OrchestrationJobDetail
        ]
      ]
    ,
      name: 'extractors'
      title: 'Extractors'
      defaultRouteHandler: createComponentsIndex('extractor')
      childRoutes: [
        name: 'new-extractor'
        handler: createNewComponentPage('extractor')
      ]
    ,
      name: 'writers'
      title: 'Writers'
      defaultRouteHandler: createComponentsIndex('writer')
      childRoutes: [
        name: 'new-writer'
        handler: createNewComponentPage('writer')
      ]
    ,
      name: 'storage'
      title: 'Storage'
      handler: Storage
  ]



module.exports = routes