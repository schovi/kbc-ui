_ = require 'underscore'
index = require './react/pages/Index/Index'
tableDetail = require './react/pages/Table/Table'
tableEditButtons = require './react/components/TableHeaderButtons'

installedComponentsActions = require '../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'
storageActionCreators = require '../components/StorageActionCreators'
ComponentsStore = require '../components/stores/ComponentsStore'

componentId = 'tde-exporter'

module.exports =
  name: componentId
  path: "#{componentId}/:config"
  defaultRouteHandler: index
  isComponent: true
  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData componentId, params.config
    ,
      ->
        storageActionCreators.loadTables()
      ->
        tags = ['tde', 'table-export']
        params = "q": _.map(tags, (t) -> "+tags:#{t}").join(' ')
        console.log "loaaad files", params
        storageActionCreators.loadFiles(params)
  ]
  title: (routerState) ->
    component = ComponentsStore.getComponent componentId
    configId = routerState.getIn ['params', 'config']
    componentName = component.get 'name'
    configName = InstalledComponentsStore.getConfig(componentId, configId).get('name')
    return "#{componentName} - #{configName}"

  childRoutes: [
    #isComponent: true
    name: "tde-exporter-table"
    path: 'table/:tableId'
    handler: tableDetail
    headerButtonsHandler: tableEditButtons
    title: (routerState) ->
      tableId = routerState.getIn ['params', 'tableId']
      return tableId
  ]
