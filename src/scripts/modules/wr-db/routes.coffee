dbwrIndex = require './react/pages/index/Index'
dbWrTableDetail = require './react/pages/table/Table'
dbWrCredentialsDetail = require './react/pages/credentials/Credentials'
ActionCreators = require './actionCreators'
InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'
ComponentsStore = require '../components/stores/ComponentsStore'
CredentialsHeader = require './react/components/CredentialsHeaderButtons'
storageActionCreators = require '../components/StorageActionCreators'

#driver = 'mysql'
#componentId = 'wr-db'

createRoute = (componentId, driver, isProvisioning) ->
  name: componentId
  path: ":config"
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    InstalledComponentsStore.getConfig(componentId, configId).get('name')
  isComponent: true
  defaultRouteHandler: dbwrIndex(componentId)
  requireData: [
    (params) ->
      ActionCreators.loadConfiguration componentId, params.config
    ,
      ->
        storageActionCreators.loadTables()

  ]
  childRoutes: [
    #isComponent: true
    name: "#{componentId}-table"
    path: 'table/:tableId'
    handler: dbWrTableDetail(componentId)
    title: (routerState) ->
      tableId = routerState.getIn ['params', 'tableId']
      return tableId

    requireData: [
      (params) ->
        ActionCreators.loadTableConfig componentId, params.config, params.tableId
    ]
  ,
    name: "#{componentId}-credentials"
    path: 'credentials'
    handler: dbWrCredentialsDetail(componentId, driver, isProvisioning)
    headerButtonsHandler: CredentialsHeader(componentId, driver, isProvisioning)
    title: (routerState) ->
      'Credentials'
  ]

module.exports = createRoute
