
actionCreators = require './actionCreators'
InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'
GoodDataWriterStore = require './store'

IndexPage = require './react/pages/index/Index'
TablePage = require './react/pages/table/Table'

module.exports =
  name: 'gooddata-writer'
  path: 'gooddata-writer/:config'
  isComponent: true
  requireData: [
    (params) ->
      actionCreators.loadConfiguration params.config
  ]
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    'Database - ' + InstalledComponentsStore.getConfig('gooddata-writer', configId).get 'name'
  defaultRouteHandler: IndexPage
  childRoutes: [
    name: 'gooddata-writer-table'
    path: 'table/:table'
    requireData: [
      (params) ->
        actionCreators.loadTableDetail(params.config, params.table)
    ]
    title: ->
      'table'
    handler: TablePage
  ]
