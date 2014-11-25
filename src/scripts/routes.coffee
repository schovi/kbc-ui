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

routes =
  Route({handler: App, path: '/'},
    Route({handler: Transformations, name: 'transformations'}),

    Route({handler: Dummy, name: 'orchestrations'},
      DefaultRoute({handler: OrchestrationsIndex, name: 'orchestrationsIndex'})
      Route({handler: Dummy, name: 'orchestration', path: ':orchestrationId'},
        DefaultRoute({handler: OrchestrationDetail, name: 'orchestrationDetail'})
        Route(handler: OrchestrationJobDetail, name: 'orchestrationJob', path: 'jobs/:jobId')
      )
    )
    Route({handler: Dummy, name: 'extractors'}
      DefaultRoute({handler: createComponentsIndex('extractor'), name: 'extractorsIndex'})
      Route({handler: createNewComponentPage('extractor'), name: 'new-extractor'})
    ),
    Route({handler: Dummy, name: 'writers'}
      DefaultRoute({handler: createComponentsIndex('writer'), name: 'writersIndex', isDefault :true})
      Route({handler: createNewComponentPage('writer'), name: 'new-writer'})
    ),
    Route({handler: Storage, name: 'storage'})

    DefaultRoute({handler: Home, name: 'home'})
    NotFoundRoute({handler: NotFound})
  )

module.exports = routes