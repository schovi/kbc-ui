Dispatcher = require('../../Dispatcher')
{Map, fromJS, List} = require 'immutable'

StoreUtils = require('../../utils/StoreUtils')
constants = require './constants'


_store = Map
  credentials: Map() #driver#configId
  tables: Map() #driver#configId
  columns: Map() #driver#configId#tableId
  updatingTables: Map() #driver#configId#tableId


WrDbStore = StoreUtils.createStore

  hasConfiguration: (driver, configId) ->
    @hasTables(driver, configId)

  hasTables: (driver, configId) ->
    _store.hasIn ['tables', driver, configId]

  getTables: (driver, configId) ->
    _store.getIn ['tables', driver, configId]

  hasCredentials: (driver, configId) ->
    _store.hasIn ['credentials', driver, configId]

  getCredentials: (driver, configId) ->
    _store.getIn ['credentials', driver, configId]

  isUpdatingTable: (driver, configId, tableId) ->
    _store.hasIn ['updatingTables', driver, configId, tableId]

  getUpdatingTables: (driver, configId) ->
    _store.getIn ['updatingTables', driver, configId], Map()

Dispatcher.register (payload) ->
  action = payload.action
  switch action.type
    when constants.ActionTypes.WR_DB_SET_TABLE_START
      driver = action.driver
      configId = action.configId
      tableId = action.tableId
      _store = _store.setIn ['updatingTables', driver, configId, tableId], true
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_SET_TABLE_SUCCESS
      driver = action.driver
      configId = action.configId
      tableId = action.tableId
      dbName = action.dbName
      isExported = action.isExported
      _store = _store.deleteIn ['updatingTables', driver, configId, tableId]

      tables = WrDbStore.getTables(driver, configId)
      table = tables.find (table) ->
        table.get('id') == tableId
      if not table
        table = fromJS
          id: tableId
          name: dbName
          export: isExported
      else
        table = table.set('dbName', dbName)
        table = table.set('export', isExported)
      tables = tables.map (t) ->
        if t.get('id') == tableId
          return t = table
        return t
      _store = _store.setIn ['tables', driver, configId], tables
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_GET_CONFIGURATION_SUCCESS
      driver = action.driver
      configId = action.configId
      credentials = action.config.credentials
      tables = action.config.tables
      _store = _store.setIn ['tables',      driver, configId], fromJS(tables)
      _store = _store.setIn ['credentials', driver, configId], fromJS(credentials)
      WrDbStore.emitChange()

module.exports = WrDbStore
