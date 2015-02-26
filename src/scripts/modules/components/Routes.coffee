React = require 'react'

createComponentsIndex = require './react/pages/ComponentsIndex'
createNewComponentPage = require './react/pages/NewComponent'
createNewComponentButton = require './react/components/NewComponentButton'

NewComponentFormPage = React.createFactory(require './react/pages/new-component-form/NewComponentForm')

ComponentReloaderButton = require './react/components/ComponentsReloaderButton'
IntalledComponentsStore = require './stores/InstalledComponentsStore'
ComponentsStore = require './stores/ComponentsStore'
InstalledComponentsActionsCreators = require './InstalledComponentsActionCreators'
ComponentsActionCreators = require './ComponentsActionCreators'

exDbRoutes = require '../ex-db/exDbRoutes'
exGdriveGoogleRoutes = require '../ex-google-drive/exGdriveRoutes'
exGanalRoutes = require '../ex-google-analytics/exGanalRoutes'

routes =

  extractors:
    name: 'extractors'
    title: 'Extractors'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: createComponentsIndex('extractor')
    headerButtonsHandler: createNewComponentButton('New Extractor', 'new-extractor')
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-extractor'
      title: 'New Extractor'
      defaultRouteHandler: createNewComponentPage('extractor')
      childRoutes: [
        name: 'new-extractor-form'
        title: (routerState) ->
          componentId = routerState.getIn ['params', 'componentId']
          ComponentsStore.getComponent(componentId).get 'name'
        path: ':componentId'
        handler: NewComponentFormPage
        requireData: (params) ->
          ComponentsActionCreators.loadComponent params.componentId
      ]
    ,
      exDbRoutes
    ,
      exGdriveGoogleRoutes
    ,
      exGanalRoutes
    ]

  writers:
    name: 'writers'
    title: 'Writers'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: createComponentsIndex('writer')
    headerButtonsHandler: createNewComponentButton('New Writer', 'new-writer')
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-writer'
      title: 'New Writer'
      defaultRouteHandler: createNewComponentPage('writer')
      childRoutes: [
        name: 'new-writer-form'
        title: (routerState) ->
          componentId = routerState.getIn ['params', 'componentId']
          ComponentsStore.getComponent(componentId).get 'name'
        path: ':componentId'
        handler: NewComponentFormPage
        requireData: (params) ->
          ComponentsActionCreators.loadComponent params.componentId
      ]
    ]


module.exports = routes
