dbwrIndex = require './react/pages/index/Index'
dbWrTableDetail = require './react/pages/table/Table'
ActionCreators = require './actionCreators'
InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'
ComponentsStore = require '../components/stores/ComponentsStore'

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
  defaultRouteHandler: dbwrIndex
  requireData: [
    (params) ->
      ActionCreators.loadConfiguration driver, params.config
  ]
  childRoutes: [
    #isComponent: true
    name: 'wr-db-table'
    path: 'table/:tableId'
    handler: dbWrTableDetail
    title: (routerState) ->
      tableId = routerState.getIn ['params', 'tableId']
      return tableId

    requireData: [
      (params) ->
        ActionCreators.loadTableConfig driver, params.config, params.tableId
    ]
  ]
