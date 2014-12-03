React = require 'react'
Router = require 'react-router'
App = require './components/App.coffee'



# class factories parametrized by component type
createComponentsIndex = require './components/components/ComponentsIndex.coffee'
createNewComponentPage = require './components/components/NewComponent.coffee'
createNewComponentButton = require './components/components/NewComponentButton.coffee'
ComponentReloaderButton = require './components/components/ComponentsReloaderButton.coffee'


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
      require './modules/orchestrations/routes.coffee'
    ,
      name: 'extractors'
      title: 'Extractors'
      defaultRouteHandler: createComponentsIndex('extractor')
      headerButtonsHandler: createNewComponentButton('New Extractor', 'new-extractor')
      reloaderHandler: ComponentReloaderButton
      childRoutes: [
        name: 'new-extractor'
        title: 'New Extractor'
        handler: createNewComponentPage('extractor')
      ]
    ,
      name: 'writers'
      title: 'Writers'
      defaultRouteHandler: createComponentsIndex('writer')
      headerButtonsHandler: createNewComponentButton('New Writer', 'new-writer')
      reloaderHandler: ComponentReloaderButton
      childRoutes: [
        name: 'new-writer'
        title: 'New Writer'
        handler: createNewComponentPage('writer')
      ]
    ,
      name: 'storage'
      title: 'Storage'
      handler: Storage
  ]



module.exports = routes