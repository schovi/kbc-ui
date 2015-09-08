React = require 'react'

injectProps = require './react/injectProps'
ComponentsIndex = require './react/pages/ComponentsIndex'
NewComponent = require './react/pages/NewComponent'
NewComponentButton = require './react/components/NewComponentButton'


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
createDbWriterRoutes = require '../wr-db/routes'
createGenericDetailRoute = require './createGenericDetailRoute'
googleDriveWriterRoutes = require '../wr-google-drive/wrGdriveRoutes'
tdeRoutes = require '../tde-exporter/tdeRoutes'
adformRoutes = require '../ex-adform/routes'
geneeaGeneralRoutes = require '../app-geneea-nlp-analysis/routes.js'

extractor = injectProps(type: 'extractor')
writer = injectProps(type: 'writer')
application = injectProps(type: 'application')



routes =

  applications:
    name: 'applications'
    title: 'Applications'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: application(ComponentsIndex)
    headerButtonsHandler: injectProps(
      text: 'New Application'
      to: 'new-application'
      type: 'application'
    )(NewComponentButton)
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-application'
      title: 'New Application'
      defaultRouteHandler: application(NewComponent)
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
      geneeaGeneralRoutes
    ,
      createGenericDetailRoute 'application'
    ]

  extractors:
    name: 'extractors'
    title: 'Extractors'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: extractor(ComponentsIndex)
    headerButtonsHandler: injectProps(text: 'New Extractor', to: 'new-extractor', type: 'extractor')(NewComponentButton)
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-extractor'
      title: 'New Extractor'
      defaultRouteHandler: extractor(NewComponent)
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
      adformRoutes
    ,
      createGenericDetailRoute 'extractor'
    ]

  writers:
    name: 'writers'
    title: 'Writers'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: writer(ComponentsIndex)
    headerButtonsHandler: injectProps(text: 'New Writer', to: 'new-writer', type: 'writer')(NewComponentButton)
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-writer'
      title: 'New Writer'
      defaultRouteHandler: writer(NewComponent)
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
      tdeRoutes
    ,
      googleDriveWriterRoutes
    ,
      createDbWriterRoutes('wr-db', 'mysql', true)
    ,
      createDbWriterRoutes('wr-db-mysql', 'mysql', true)
    ,
      createDbWriterRoutes('wr-db-oracle', 'oracle', false)
    ,
      createDbWriterRoutes('wr-db-redshift', 'redshift', true)
    ,
      createDbWriterRoutes('wr-tableau', 'mysql', true)
    ,
      createGenericDetailRoute 'writer'

    ]


module.exports = routes
