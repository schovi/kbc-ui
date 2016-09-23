React = require 'react'
IntalledComponentsStore = require '../components/stores/InstalledComponentsStore'
actionsProvisioning = require './actionsProvisioning'
VersionsActionCreators = require '../components/VersionsActionCreators'
ExDbIndex = require './react/pages/index/Index'
ExDbCredentialsPage = require('./react/pages/credentials/CredentialsPage').default
ExDbNewCredentialsPage = require('./react/pages/credentials/NewCredentialsPage').default
ExDbQueryDetail = require './react/pages/query-detail/QueryDetail'
ExDbNewQuery = require './react/pages/new-query/NewQuery'
ExDbNewQueryHeaderButtons = require './react/components/NewQueryHeaderButtons'
ExDbQueryHeaderButtons = require('./react/components/QueryActionButtons').default
ExDbCredentialsHeaderButtons = require './react/components/CredentialsHeaderButtons'
ExDbNewCredentialsHeaderButtons = require('./react/components/NewCredentialsHeaderButtons').default
ExDbQueryName = require './react/components/QueryName'

createVersionsPageRoute = require('../../modules/components/utils/createVersionsPageRoute').default
injectProps = require('../components/react/injectProps').default


JobsActionCreators = require '../jobs/ActionCreators'
StorageActionCreators = require('../components/StorageActionCreators')

storeProvisioning = require './storeProvisioning'

credentialsTemplate = require './templates/credentials'
hasSshTunnel = require('../ex-db-generic/templates/hasSshTunnel').default

module.exports = (componentId) ->
  name: componentId
  path: ':config'
  isComponent: true
  requireData: [
    (params) ->
      actionsProvisioning.loadConfiguration componentId, params.config
    (params) ->
      VersionsActionCreators.loadVersions(componentId, params.config)
  ]
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    IntalledComponentsStore.getConfig(componentId, configId).get 'name'
  poll:
    interval: 5
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs(componentId, params.config)
  defaultRouteHandler: ExDbIndex(componentId)
  childRoutes: [
    createVersionsPageRoute(componentId, 'config')
  ,
    name: "ex-db-generic-#{componentId}-query"
    path: 'query/:query'
    title: (routerState) ->
      configId = routerState.getIn ['params', 'config']
      queryId = routerState.getIn ['params', 'query']
      ExDbStore = storeProvisioning.createStore(componentId, configId)
      'Query ' + ExDbStore.getConfigQuery(parseInt(queryId)).get 'name'
    nameEdit: (params) ->
      React.createElement ExDbQueryName(componentId, storeProvisioning),
        configId: params.config
        queryId: parseInt params.query
    requireData: [
      ->
        StorageActionCreators.loadTables()
    ]
    handler: ExDbQueryDetail(componentId, actionsProvisioning, storeProvisioning)
    headerButtonsHandler: ExDbQueryHeaderButtons(componentId, actionsProvisioning, storeProvisioning)
  ,
    name: "ex-db-generic-#{componentId}-new-query"
    path: 'new-query'
    title: ->
      'New query'
    requireData: [
      ->
        StorageActionCreators.loadTables()
    ]
    handler: ExDbNewQuery(componentId)
    headerButtonsHandler: ExDbNewQueryHeaderButtons(componentId, actionsProvisioning, storeProvisioning)
  ,
    name: "ex-db-generic-#{componentId}-credentials"
    path: 'credentials'
    title: ->
      'Credentials'
    handler: ExDbCredentialsPage(
      componentId, actionsProvisioning, storeProvisioning, credentialsTemplate, hasSshTunnel
    )
    headerButtonsHandler: ExDbCredentialsHeaderButtons(componentId, actionsProvisioning, storeProvisioning)
  ,
    name: "ex-db-generic-#{componentId}-new-credentials"
    path: 'new-credentials'
    title: ->
      'New Credentials'
    handler: ExDbNewCredentialsPage(
      componentId, actionsProvisioning, storeProvisioning, credentialsTemplate, hasSshTunnel
    )
    headerButtonsHandler: ExDbNewCredentialsHeaderButtons(componentId, actionsProvisioning, storeProvisioning)
  ]
