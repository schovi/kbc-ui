React = require 'react'
Router = require 'react-router'
App = require './components/App.coffee'

OrchestrationsIndex = require './components/orchestrations/OrchestrationsIndex.coffee'
OrchestrationDetail = require './components/orchestrations/OrchestrationDetail.coffee'
ComponentsIndex = require './components/components/ComponentsIndex.coffee'
NewComponent = require './components/components/NewComponent.coffee'

Routes = React.createFactory(Router.Routes)
Route = React.createFactory(Router.Route)


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
      Route({handler: React.createFactory(ComponentsIndex), mode:'extractor', name: 'extractorsIndex', isDefault :true})
      Route({handler: React.createFactory(NewComponent), mode:'extractor', name: 'new-extractor'})
    ),
    Route({handler: React.createFactory(Dummy), name: 'writers'}
      Route({handler: React.createFactory(ComponentsIndex), mode:'writer', name: 'writersIndex', isDefault :true})
    ),
    Route({handler: React.createFactory(Storage), name: 'storage'})
    Route({handler: React.createFactory(Home), name: 'home', path: null, isDefault: true}),
    Route({handler: React.createFactory(NotFound), catchAll: true, path: null})
  )
)


React.render(routes, document.getElementById 'react')