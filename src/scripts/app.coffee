React = require 'react'
Router = require 'react-router'
App = require './components/App.coffee'

Routes = React.createFactory(Router.Routes)
Route = React.createFactory(Router.Route)


Orchestrations = React.createClass
  displayName: 'Orchestrations'
  render: ->
    React.DOM.div null, 'Orchestrations'

Transformations = React.createClass
  displayName: 'Transformations'
  render: ->
    React.DOM.div null, 'Transformations'

Extractors = React.createClass
  displayName: 'Extractors'
  render: ->
    React.DOM.div null, 'Extractors'

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

routes = Routes(location: 'history',
  Route({handler: React.createFactory(App)},
    Route({handler: React.createFactory(Transformations), name: 'transformations'}),
    Route({handler: React.createFactory(Orchestrations), name: 'orchestrations'}),
    Route({handler: React.createFactory(Extractors), name: 'extractors'}),
    Route({handler: React.createFactory(Writers), name: 'writers'}),
    Route({handler: React.createFactory(Home), name: 'home', path: null, isDefault: true}),
    Route({handler: React.createFactory(NotFound), catchAll: true, path: null})
  )
)


React.render(routes, document.getElementById 'react')