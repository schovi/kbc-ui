#React = require 'react'

injectProps = require('./react/injectProps').default
ComponentsIndex = require('./react/pages/ComponentsIndex')
NewComponent = require('./react/pages/NewComponent').default
NewComponentButton = require './react/components/NewComponentButton'
AddComponentConfigurationButton = require './react/components/AddComponentConfigurationButton'


NewComponentFormPage = require './react/pages/new-component-form/NewComponentForm'
ComponentDetail = require './react/pages/component-detail/ComponentDetail'

ComponentReloaderButton = require './react/components/ComponentsReloaderButton'
ComponentsStore = require './stores/ComponentsStore'
InstalledComponentsActionsCreators = require './InstalledComponentsActionCreators'
ComponentsActionCreators = require './ComponentsActionCreators'


exDbRoutes = require '../ex-db/exDbRoutes'
exGdriveGoogleRoutes = require '../ex-google-drive/exGdriveRoutes'
exGanalRoutes = require '../ex-google-analytics/exGanalRoutes'
appGeneeaRoutes = require '../app-geneea/appGeneeaRoutes'
goodDataWriterRoutes = require '../gooddata-writer/routes'
dropoxExtractorRoutes = require('../ex-dropbox/routes').default
dropoxWriterRoutes = require '../wr-dropbox/routes'
createDbWriterRoutes = require '../wr-db/routes'
createGenericDetailRoute = require './createGenericDetailRoute'
createGenericNewRoute = require './createGenericNewRoute'
googleDriveWriterRoutes = require '../wr-google-drive/wrGdriveRoutes'
tdeRoutes = require '../tde-exporter/tdeRoutes'
adformRoutes = require('../ex-adform/routes').default
geneeaGeneralRoutes = require('../app-geneea-nlp-analysis/routes').default
customScienceRoutes = require('../custom-science/Routes').default
NewComponentFormPage = require '../components/react/pages/new-component-form/NewComponentForm'

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
        name: 'new-application-add'
        title: (routerState) ->
          component = routerState.getIn ['params', 'component']
          'New ' + ComponentsStore.getComponent(component).get('name') + ' Configuration'
        path: ':component'
        defaultRouteHandler: NewComponentFormPage
        requireData: (params) ->
          ComponentsActionCreators.loadComponent params.component
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
      createGenericNewRoute 'geneea-nlp-analysis'
    ,
      geneeaGeneralRoutes
    ,
      createGenericNewRoute 'custom-science'
    ,
      customScienceRoutes
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
        name: 'new-extractor-add'
        title: (routerState) ->
          component = routerState.getIn ['params', 'component']
          'New ' + ComponentsStore.getComponent(component).get('name') + ' Configuration'
        path: ':component'
        defaultRouteHandler: NewComponentFormPage
        requireData: (params) ->
          ComponentsActionCreators.loadComponent params.component
      ]

    ,
      createGenericNewRoute 'ex-db'
    ,
      exDbRoutes
    ,
      createGenericNewRoute 'ex-google-drive'
    ,
      exGdriveGoogleRoutes
    ,
      createGenericNewRoute 'ex-google-analytics'
    ,
      exGanalRoutes
    ,
      createGenericNewRoute 'ex-adform'
    ,
      adformRoutes
    ,
      dropoxExtractorRoutes
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
        name: 'new-writer-add'
        title: (routerState) ->
          component = routerState.getIn ['params', 'component']
          'New ' + ComponentsStore.getComponent(component).get('name') + ' Configuration'
        path: ':component'
        defaultRouteHandler: NewComponentFormPage
        requireData: (params) ->
          ComponentsActionCreators.loadComponent params.component
      ]
    ,
      createGenericNewRoute 'gooddata-writer'
    ,
      goodDataWriterRoutes
    ,
      createGenericNewRoute 'wr-dropbox'
    ,
      dropoxWriterRoutes
    ,
      createGenericNewRoute 'tde-exporter'
    ,
      tdeRoutes
    ,
      createGenericNewRoute 'wr-google-drive'
    ,
      googleDriveWriterRoutes
    ,
      createGenericNewRoute 'wr-db'
    ,
      createDbWriterRoutes('wr-db', 'mysql', true)
    ,
      createGenericNewRoute 'wr-db-mysql'
    ,
      createDbWriterRoutes('wr-db-mysql', 'mysql', true)
    ,
      createGenericNewRoute 'wr-db-oracle'
    ,
      createDbWriterRoutes('wr-db-oracle', 'oracle', false)
    ,
      createGenericNewRoute 'wr-db-redshift'
    ,
      createDbWriterRoutes('wr-db-redshift', 'redshift', true)
    ,
      createGenericNewRoute 'wr-tableau'
    ,
      createDbWriterRoutes('wr-tableau', 'mysql', true)
    ,
      createGenericDetailRoute 'writer'

    ]

module.exports = routes
