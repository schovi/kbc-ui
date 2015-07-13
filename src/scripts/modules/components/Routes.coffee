React = require 'react'

createComponentsIndex = require './react/pages/ComponentsIndex'
createNewComponentPage = require './react/pages/NewComponent'
createNewComponentButton = require './react/components/NewComponentButton'


NewComponentFormPage = require './react/pages/new-component-form/NewComponentForm'

ComponentReloaderButton = require './react/components/ComponentsReloaderButton'
ComponentsStore = require './stores/ComponentsStore'
InstalledComponentsActionsCreators = require './InstalledComponentsActionCreators'
ComponentsActionCreators = require './ComponentsActionCreators'


exDbRoutes = require '../ex-db/exDbRoutes'
exGdriveGoogleRoutes = require '../ex-google-drive/exGdriveRoutes'
exGanalRoutes = require '../ex-google-analytics/exGanalRoutes'
appGeneeaRoutes = require '../app-geneea/appGeneeaRoutes'
goodDataWriterRoutes = require '../gooddata-writer/routes'
dropoxWriterRoutes = require '../wr-dropbox/routes'
dbWriterRoutes = require '../wr-db/routes'
createGenericDetailRoute = require './createGenericDetailRoute'

routes =

  applications:
    name: 'applications'
    title: 'Applications'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: createComponentsIndex('application')
    headerButtonsHandler: createNewComponentButton('New Application', 'new-application', 'application')
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-application'
      title: 'New Application'
      defaultRouteHandler: createNewComponentPage('application')
      childRoutes: [
        name: 'new-application-form'
        title: (routerState) ->
          componentId = routerState.getIn ['params', 'componentId']
          ComponentsStore.getComponent(componentId).get 'name'
        path: ':componentId'
        handler: NewComponentFormPage
        requireData: (params) ->
          ComponentsActionCreators.loadComponent params.componentId
      ]
    ,
      appGeneeaRoutes.sentimentAnalysis
    ,
      appGeneeaRoutes.topicDetection
    ,
      appGeneeaRoutes.lemmatization
    ,
      appGeneeaRoutes.correction
    ,
      appGeneeaRoutes.languageDetection
    ,
      appGeneeaRoutes.entityRecognition
    ,
      createGenericDetailRoute 'application'
    ]

  extractors:
    name: 'extractors'
    title: 'Extractors'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: createComponentsIndex('extractor')
    headerButtonsHandler: createNewComponentButton('New Extractor', 'new-extractor', 'extractor')
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
    ,
      createGenericDetailRoute 'extractor'
    ]

  writers:
    name: 'writers'
    title: 'Writers'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: createComponentsIndex('writer')
    headerButtonsHandler: createNewComponentButton('New Writer', 'new-writer', 'writer')
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
    ,
      goodDataWriterRoutes
    ,
      dropoxWriterRoutes
    ,
      dbWriterRoutes
    ,
      createGenericDetailRoute 'writer'

    ]


module.exports = routes
