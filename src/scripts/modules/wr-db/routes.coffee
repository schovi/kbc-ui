dbwrIndex = require './react/pages/index/Index'
dbWrTableDetail = require './react/pages/table/Table'
dbWrCredentialsDetail = require './react/pages/credentials/Credentials'
ActionCreators = require './actionCreators'
VersionsActionCreators = require '../components/VersionsActionCreators'
InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'
ComponentsStore = require '../components/stores/ComponentsStore'
CredentialsHeader = require './react/components/CredentialsHeaderButtons'
storageActionCreators = require '../components/StorageActionCreators'
JobsActionCreators = require '../jobs/ActionCreators'
DockerProxyApi = require('./templates/dockerProxyApi').default
#driver = 'mysql'
#componentId = 'wr-db'

createRoute = (componentId, driver, isProvisioning) ->
  dockerProxyActions = DockerProxyApi(componentId)
  name: componentId
  path: ":config"
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    InstalledComponentsStore.getConfig(componentId, configId).get('name')
  isComponent: true
  poll:
    interval: 5
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs(componentId, params.config)
  defaultRouteHandler: dbwrIndex(componentId)
  requireData: [
    (params) ->
      prepareWriterDataFn = ->
        ActionCreators.loadConfiguration(componentId, params.config)
      dockerPromise = dockerProxyActions?.loadConfigData(params.config)
      if dockerPromise
        return dockerPromise.then ->
          prepareWriterDataFn()
      else
        prepareWriterDataFn()
    ,
      ->
        storageActionCreators.loadTables()
    (params) ->
      VersionsActionCreators.loadVersions(componentId, params.config)

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
        return ActionCreators.loadTableConfig componentId, params.config, params.tableId
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
