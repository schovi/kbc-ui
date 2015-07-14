{Map, FromJS, List} = require 'immutable'

StoreUtils = require('../../utils/StoreUtils')
dispatcher = require '../../Dispatcher'
constants = require './constants'


_store = Map
  credentials: Map() #driver#configId
  tables: Map() #driver#configId
  columns: Map() #driver#configId#tableId


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


dispatcher.reqister (payload) ->
  action = payload.action
  switch action.type
    when constants.ActionTypes.WR_DB_GET_CONFIGURATION_SUCCESS
      driver = action.driver
      configId = action.configId
      credentials = action.config.credentials
      tables = action.config.tables
      _store = _store.setIn ['tables',      driver, configId], FromJS(tables)
      _store = _store.setIn ['credentials', driver, configId], FromJS(credentials)
      WrDbStore.emitChange()
