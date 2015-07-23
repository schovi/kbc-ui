dbwrIndex = require './react/pages/index/Index'
dbWrTableDetail = require './react/pages/table/Table'
dbWrCredentialsDetail = require './react/pages/credentials/Credentials'
ActionCreators = require './actionCreators'
InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'
ComponentsStore = require '../components/stores/ComponentsStore'
CredentialsHeader = require './react/components/CredentialsHeaderButtons'

driver = 'mysql'
componentId = 'wr-db'

module.exports =
  name: 'wr-db'
  path: 'wr-db/:config'
  title: (routerState) ->
    component = ComponentsStore.getComponent componentId
    configId = routerState.getIn ['params', 'config']
    componentName = component.get 'name'
    configName = InstalledComponentsStore.getConfig(componentId, configId).get('name')
    return "#{componentName} - #{configName}"
  isComponent: true
  defaultRouteHandler: dbwrIndex(componentId, driver)
  requireData: [
    (params) ->
      ActionCreators.loadConfiguration componentId, params.config
  ]
  childRoutes: [
    #isComponent: true
    name: 'wr-db-table'
    path: 'table/:tableId'
    handler: dbWrTableDetail(componentId, driver)
    title: (routerState) ->
      tableId = routerState.getIn ['params', 'tableId']
      return tableId

    requireData: [
      (params) ->
        ActionCreators.loadTableConfig componentId, params.config, params.tableId
    ]
  ,
    name: 'wr-db-credentials'
    path: 'credentials'
    handler: dbWrCredentialsDetail(componentId, driver, true)
    headerButtonsHandler: CredentialsHeader(componentId, driver, true)
    title: (routerState) ->
      'Credentials'
    # requireData: [
    #   (params) ->
    #     ActionCreators.loadTableConfig componentId, params.config, params.tableId
    # ]

  ]
