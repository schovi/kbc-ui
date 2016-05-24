#React = require 'react'

injectProps = require('./react/injectProps').default
ComponentsIndex = require('./react/pages/ComponentsIndex')
NewComponent = require('./react/pages/NewComponent').default
NewComponentButton = require './react/components/NewComponentButton'

ComponentDetail = require './react/pages/component-detail/ComponentDetail'

ComponentReloaderButton = require './react/components/ComponentsReloaderButton'
ComponentsStore = require './stores/ComponentsStore'
InstalledComponentsActionsCreators = require './InstalledComponentsActionCreators'
ComponentsActionCreators = require './ComponentsActionCreators'


exDbRoutes = require '../ex-db/exDbRoutes'
exDbGenericRoutes = require '../ex-db-generic/routes'
exMongoDbRoutes = require '../ex-mongodb/routes'
exGdriveGoogleRoutes = require '../ex-google-drive/exGdriveRoutes'
exGanalRoutes = require '../ex-google-analytics/exGanalRoutes'
exGaV4Routes = require('../ex-google-analytics-v4/routes').default
appGeneeaRoutes = require '../app-geneea/appGeneeaRoutes'
goodDataWriterRoutes = require '../gooddata-writer/routes'
dropoxExtractorRoutes = require('../ex-dropbox/routes').default
dropoxWriterRoutes = require '../wr-dropbox/routes'
wrPortalCreateRouteFn = require('../wr-portal/Routes').default
createDbWriterRoutes = require '../wr-db/routes'

createGenericDetailRoute = require './createGenericDetailRoute'
createComponentRoute = require('./createComponentRoute').default

googleDriveWriterRoutes = require '../wr-google-drive/wrGdriveRoutes'
tdeRoutes = require '../tde-exporter/tdeRoutes'
adformRoutes = require('../ex-adform/routes').default
twitterRoutes = require('../ex-twitter/routes').default
geneeaGeneralRoutes = require('../app-geneea-nlp-analysis/routes').default
customScienceRoutes = require('../custom-science/Routes').default

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
      createComponentRoute 'geneea-nlp-analysis', [geneeaGeneralRoutes]
    ,
      createComponentRoute 'custom-science', [customScienceRoutes]
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
    ,
      createComponentRoute 'ex-db', [exDbRoutes]
    ,
      createComponentRoute 'ex-google-drive', [exGdriveGoogleRoutes]
    ,
      createComponentRoute 'ex-google-analytics', [exGanalRoutes]
      createComponentRoute 'keboola.ex-google-analytics-v4', [exGaV4Routes]
    ,
      createComponentRoute 'ex-adform', [adformRoutes]
    ,
      createComponentRoute 'keboola.ex-twitter', [twitterRoutes]
    ,
      createComponentRoute 'ex-dropbox', [dropoxExtractorRoutes]
    ,
      createComponentRoute 'keboola.ex-db-pgsql', [exDbGenericRoutes('keboola.ex-db-pgsql')]
      createComponentRoute 'keboola.ex-db-firebird', [exDbGenericRoutes('keboola.ex-db-firebird')]
      createComponentRoute 'keboola.ex-db-db2', [exDbGenericRoutes('keboola.ex-db-db2')]
      createComponentRoute 'keboola.ex-db-db2-bata', [exDbGenericRoutes('keboola.ex-db-db2-bata')]
      createComponentRoute 'keboola.ex-db-mssql', [exDbGenericRoutes('keboola.ex-db-mssql')]
      createComponentRoute 'keboola.ex-db-mysql', [exDbGenericRoutes('keboola.ex-db-mysql')]
      createComponentRoute 'keboola.ex-db-oracle', [exDbGenericRoutes('keboola.ex-db-oracle')]
    ,
      createComponentRoute 'keboola.ex-db-impala', [exDbGenericRoutes('keboola.ex-db-impala')]
    ,
      createComponentRoute 'keboola.ex-mongodb', [exMongoDbRoutes('keboola.ex-mongodb')]
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
    ,
      createComponentRoute 'gooddata-writer', [goodDataWriterRoutes]
    ,
      createComponentRoute 'wr-dropbox', [dropoxWriterRoutes]
    ,
      createComponentRoute 'tde-exporter', [tdeRoutes]
    ,
      createComponentRoute 'wr-google-drive', [googleDriveWriterRoutes]
    ,
      createComponentRoute 'wr-db', [createDbWriterRoutes('wr-db', 'mysql', true)]
    ,
      createComponentRoute 'wr-db-mysql', [createDbWriterRoutes('wr-db-mysql', 'mysql', true)]
    ,
      createComponentRoute 'wr-db-oracle', [createDbWriterRoutes('wr-db-oracle', 'oracle', false)]
    ,
      createComponentRoute 'wr-db-redshift', [createDbWriterRoutes('wr-db-redshift', 'redshift', true)]
    ,
      createComponentRoute 'keboola.wr-looker', [createDbWriterRoutes('keboola.wr-looker', 'redshift', true)]
    ,
      createComponentRoute 'keboola.wr-qlik', [createDbWriterRoutes('keboola.wr-qlik', 'redshift', true)]
    ,
      createComponentRoute 'wr-tableau', [createDbWriterRoutes('wr-tableau', 'mysql', true)]
    ,
      createComponentRoute 'wr-db-mssql', [createDbWriterRoutes('wr-db-mssql', 'mssql', false)]
    ,
      createComponentRoute 'wr-portal-sas', [wrPortalCreateRouteFn('wr-portal-sas')]
    ,
      createComponentRoute 'keboola.wr-portal-periscope', [wrPortalCreateRouteFn('keboola.wr-portal-periscope')]
    ,
      createGenericDetailRoute 'writer'

    ]

module.exports = routes
