
actionCreators = require './actionCreators'
InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'
GoodDataWriterStore = require './store'

IndexPage = require './react/pages/index/Index'
TablePage = require './react/pages/table/Table'
DateDimensionsPage = require './react/pages/date-dimensions/DateDimensions'

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
    ,
      (params) ->
        actionCreators.loadReferenceableTables(params.config)
    ]
    title: ->
      'table'
    handler: TablePage
  ,
    name: 'gooddata-writer-date-dimensions'
    title: ->
      'Date dimensions'
    requireData: [
      (params) ->
        actionCreators.loadDateDimensions params.config
    ]
    handler: DateDimensionsPage
  ]
