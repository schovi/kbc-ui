React = require 'react'
Router = require 'react-router'
App = require './components/App.coffee'

OrchestrationsIndex = require './components/orchestrations/OrchestrationsIndex.coffee'
OrchestrationDetail = require './components/orchestrations/OrchestrationDetail.coffee'
ComponentsIndex = require './components/components/ComponentsIndex.coffee'
NewComponent = require './components/components/NewComponent.coffee'
RouteHandler = React.createFactory(require('react-router').RouteHandler)

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
      Route({handler: OrchestrationDetail, name: 'orchestration', path: ':id'})
    )
    Route({handler: Dummy, name: 'extractors'}
      Route({handler: ComponentsIndex, mode:'extractor', name: 'extractorsIndex', isDefault :true})
      Route({handler: NewComponent, mode:'extractor', name: 'new-extractor'})
    ),
    Route({handler: Dummy, name: 'writers'}
      Route({handler: ComponentsIndex, mode:'writer', name: 'writersIndex', isDefault :true})
      Route({handler: NewComponent, mode:'writer', name: 'new-writer'})
    ),
    Route({handler: Storage, name: 'storage'})

    DefaultRoute({handler: Home, name: 'home'})
    NotFoundRoute({handler: NotFound})
  )

module.exports = routes