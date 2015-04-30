React = require 'react'
IntalledComponentsStore = require '../components/stores/InstalledComponentsStore'

ExDbActionCreators = require '../ex-db/exDbActionCreators'
ExDbIndex = require '../ex-db/react/pages/index/Index'
ExDbCredentials = require '../ex-db/react/pages/credentials/Credentials'
ExDbQueryDetail = require '../ex-db/react/pages/query-detail/QueryDetail'
ExDbNewQuery = require '../ex-db/react/pages/new-query/NewQuery'
ExDbNewQueryHeaderButtons = require '../ex-db/react/components/NewQueryHeaderButtons'
ExDbQueryHeaderButtons = require '../ex-db/react/components/QueryDetailHeaderButtons'
ExDbCredentialsHeaderButtons = require '../ex-db/react/components/CredentialsHeaderButtons'
ExDbQueryName = require './react/components/QueryName'

JobsActionCreators = require '../jobs/ActionCreators'
StorageActionCreators = require('../components/StorageActionCreators')

ExDbStore = require './exDbStore'

module.exports =
  name: 'ex-db'
  path: 'ex-db/:config'
  isComponent: true
  requireData: [
    (params) ->
      ExDbActionCreators.loadConfiguration params.config
  ]
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    'Database - ' + IntalledComponentsStore.getConfig('ex-db', configId).get 'name'
  poll:
    interval: 5
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs('ex-db', params.config)
  defaultRouteHandler: ExDbIndex
  childRoutes: [
    name: 'ex-db-query'
    path: 'query/:query'
    title: (routerState) ->
      configId = routerState.getIn ['params', 'config']
      queryId = routerState.getIn ['params', 'query']
      'Query ' + ExDbStore.getConfigQuery(configId, parseInt(queryId)).get 'name'
    nameEdit: (params) ->
      React.createElement ExDbQueryName,
        configId: params.config
        queryId: parseInt params.query
    requireData: [
      ->
        StorageActionCreators.loadTables()
    ]
    handler: ExDbQueryDetail
    headerButtonsHandler: ExDbQueryHeaderButtons
  ,
    name: 'ex-db-new-query'
    path: 'new-query'
    title: ->
      'New query'
    requireData: [
      ->
        StorageActionCreators.loadTables()
    ]
    handler: ExDbNewQuery
    headerButtonsHandler: ExDbNewQueryHeaderButtons
  ,
    name: 'ex-db-credentials'
    path: 'credentials'
    title: ->
      'Credentials'
    handler: ExDbCredentials
    headerButtonsHandler: ExDbCredentialsHeaderButtons
  ]
