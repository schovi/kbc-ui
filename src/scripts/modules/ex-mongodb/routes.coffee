React = require 'react'
IntalledComponentsStore = require '../components/stores/InstalledComponentsStore'
actionsProvisioning = require './actionsProvisioning'

ExDbIndex = require './react/pages/index/Index'

ExDbCredentialsPage = require('../ex-db-generic/react/pages/credentials/CredentialsPage').default
ExDbNewCredentialsPage = require('../ex-db-generic/react/pages/credentials/NewCredentialsPage').default

ExDbQueryDetail = require './react/pages/query-detail/QueryDetail'
ExDbNewQuery = require './react/pages/new-query/NewQuery'

ExDbNewQueryHeaderButtons = require '../ex-db-generic/react/components/NewQueryHeaderButtons'
ExDbQueryHeaderButtons = require('../ex-db-generic/react/components/QueryActionButtons').default
ExDbCredentialsHeaderButtons = require '../ex-db-generic/react/components/CredentialsHeaderButtons'
ExDbNewCredentialsHeaderButtons = require('../ex-db-generic/react/components/NewCredentialsHeaderButtons').default

ExDbQueryName = require '../ex-db-generic/react/components/QueryName'

JobsActionCreators = require '../jobs/ActionCreators'
StorageActionCreators = require('../components/StorageActionCreators')

storeProvisioning = require './storeProvisioning'

credentialsTemplate = require '../ex-db-generic/templates/credentials'
hasSshTunnel = require('../ex-db-generic/templates/hasSshTunnel').default

module.exports = (componentId) ->
  name: "ex-db-generic-#{componentId}"
  path: ':config'
  isComponent: true
  requireData: [
    (params) ->
      actionsProvisioning.loadConfiguration componentId, params.config
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
      'New export'
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
