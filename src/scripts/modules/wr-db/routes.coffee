dbwrIndex = require './react/pages/index/Index'
dbWrTableDetail = require './react/pages/table/Table'
ActionCreators = require './actionCreators'


driver = 'mysql'

module.exports =
  name: 'wr-db'
  path: 'wr-db/:config'
  isComponent: true
  defaultRouteHandler: dbwrIndex
  requireData: [
    (params) ->
      ActionCreators.loadConfiguration driver, params.config
  ]
  childRoutes: [
    name: 'wr-db-table'
    path: 'table/:tableId'
    handler: dbWrTableDetail
    requireData: [
      (params) ->
        ActionCreators.loadTableColumns driver, params.config, params.tableId
    ]
  ]
