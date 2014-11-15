React = require 'react'
Router = require 'react-router'
App = require './components/App.coffee'

OrchestrationsIndex = require './components/orchestrations/OrchestrationsIndex.coffee'
OrchestrationDetail = require './components/orchestrations/OrchestrationDetail.coffee'
ExtractorsIndex = require './components/extractors/ExtractorsIndex.coffee'

Routes = React.createFactory(Router.Routes)
Route = React.createFactory(Router.Route)


Transformations = React.createClass
  displayName: 'Transformations'
  render: ->
    React.DOM.div null, 'Transformations'


Writers = React.createClass
  displayName: 'Writers'
  render: ->
    React.DOM.div null, 'Writers'

Home = React.createClass
  displayName: 'Home'
  render: ->
    React.DOM.div null, 'Home'

NotFound = React.createClass
  displayName: 'NotFound'
  render: ->
    React.DOM.div null, 'Not found'

Dummy = React.createClass
  displayName: 'DummyWrapper'
  render: ->
    @props.activeRouteHandler()

routes = Routes(location: 'history',
  Route({handler: React.createFactory(App)},
    Route({handler: React.createFactory(Transformations), name: 'transformations'}),

    Route({handler: React.createFactory(Dummy), name: 'orchestrations'},
      Route({handler: React.createFactory(OrchestrationsIndex), name: 'orchestrationsIndex', isDefault :true})
      Route({handler: React.createFactory(OrchestrationDetail), name: 'orchestration', path: ':id'})
    )
    Route({handler: React.createFactory(Dummy), name: 'extractors'}
      Route({handler: React.createFactory(ExtractorsIndex), name: 'extractorsIndex', isDefault :true})
    ),
    Route({handler: React.createFactory(Writers), name: 'writers'}),
    Route({handler: React.createFactory(Home), name: 'home', path: null, isDefault: true}),
    Route({handler: React.createFactory(NotFound), catchAll: true, path: null})
  )
)


React.render(routes, document.getElementById 'react')