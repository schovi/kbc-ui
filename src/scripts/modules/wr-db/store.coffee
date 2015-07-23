Dispatcher = require('../../Dispatcher')
{Map, fromJS, List} = require 'immutable'
_ = require 'underscore'
StoreUtils = require('../../utils/StoreUtils')
constants = require './constants'


_store = Map
  credentials: Map() #componentId#configId
  tables: Map() #componentId#configId
  tablesConfig: Map() #componentId#configId#tableId
  updatingTables: Map() #componentId#configId#tableId
  editing: Map() #componentId#configId whatever
  updatingColumns: Map() #componentId#configId#tableId
  savingCredentials: Map() #componentId#configId
  provisioningCredentials: Map() #componentId#configId
  loadingProvCredentials: Map() #componentId#configId



WrDbStore = StoreUtils.createStore

  isLoadingProvCredentials: (componentId, configId) ->
    _store.hasIn ['loadingProvCredentials', componentId, configId]

  getProvisioningCredentials: (componentId, configId) ->
    _store.getIn ['provisioningCredentials', componentId, configId]

  hasConfiguration: (componentId, configId) ->
    @hasTables(componentId, configId)

  getSavingCredentials: (componentId, configId) ->
    _store.getIn ['savingCredentials', componentId, configId]

  hasTables: (componentId, configId) ->
    _store.hasIn ['tables', componentId, configId]

  getTables: (componentId, configId) ->
    _store.getIn ['tables', componentId, configId]

  hasCredentials: (componentId, configId) ->
    _store.hasIn ['credentials', componentId, configId]

  getCredentials: (componentId, configId) ->
    creds = _store.getIn ['credentials', componentId, configId]
    if _.isEmpty(creds?.toJS())
      creds = Map()
    return creds

  isUpdatingTable: (componentId, configId, tableId) ->
    _store.hasIn ['updatingTables', componentId, configId, tableId]

  getUpdatingTables: (componentId, configId) ->
    _store.getIn ['updatingTables', componentId, configId], Map()

  hasTableConfig: (componentId, configId, tableId) ->
    _store.hasIn ['tablesConfig', componentId, configId, tableId]

  getTableConfig: (componentId, configId, tableId) ->
    _store.getIn ['tablesConfig', componentId, configId, tableId]

  getEditingByPath: (componentId, configId, path) ->
    editPath = ['editing', componentId, configId].concat(path)
    _store.getIn editPath

  getEditing: (componentId, configId) ->
    _store.getIn(['editing', componentId, configId], Map())

  getUpdatingColumns: (componentId, configId, tableId) ->
    _store.getIn(['updatingColumns', componentId, configId, tableId])

Dispatcher.register (payload) ->
  action = payload.action
  switch action.type
    when constants.ActionTypes.WR_DB_LOAD_PROVISIONING_START
      componentId = action.componentId
      configId = action.configId
      _store = _store.setIn ['loadingProvCredentials', componentId, configId], true
      WrDbStore.emitChange()
    when constants.ActionTypes.WR_DB_LOAD_PROVISIONING_SUCCESS
      componentId = action.componentId
      configId = action.configId
      credentials = fromJS action.credentials
      _store = _store.deleteIn ['loadingProvCredentials', componentId, configId]
      _store = _store.setIn ['provisioningCredentials', componentId, configId], credentials
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_SAVE_CREDENTIALS_START
      componentId = action.componentId
      configId = action.configId
      credentials = action.credentials
      _store = _store.setIn ['savingCredentials', componentId, configId], credentials
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_SAVE_CREDENTIALS_SUCCESS
      componentId = action.componentId
      configId = action.configId
      credentials = action.credentials
      _store = _store.deleteIn ['savingCredentials', componentId, configId]
      _store = _store.setIn ['credentials', componentId, configId], fromJS(credentials)
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_SAVE_COLUMNS_START
      componentId = action.componentId
      configId = action.configId
      tableId = action.tableId
      columns = action.columns
      _store = _store.setIn ['updatingColumns', componentId, configId, tableId], columns
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_SAVE_COLUMNS_SUCCESS
      componentId = action.componentId
      configId = action.configId
      tableId = action.tableId
      columns = action.columns
      _store = _store.deleteIn ['updatingColumns', componentId, configId, tableId]
      _store = _store.setIn ['tablesConfig', componentId, configId, tableId, 'columns'], columns
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_SET_EDITING
      componentId = action.componentId
      configId = action.configId
      path = action.path
      data = action.data
      editPath = ['editing', componentId, configId].concat(path)
      _store = _store.setIn editPath, data
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_GET_TABLE_SUCCESS
      componentId = action.componentId
      configId = action.configId
      tableId = action.tableId
      tableConfig = action.tableConfig
      _store = _store.setIn ['tablesConfig', componentId, configId, tableId], fromJS(tableConfig)
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_SET_TABLE_START
      componentId = action.componentId
      configId = action.configId
      tableId = action.tableId
      _store = _store.setIn ['updatingTables', componentId, configId, tableId], true
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_SET_TABLE_SUCCESS
      componentId = action.componentId
      configId = action.configId
      tableId = action.tableId
      dbName = action.dbName
      isExported = action.isExported
      _store = _store.deleteIn ['updatingTables', componentId, configId, tableId]

      tables = WrDbStore.getTables(componentId, configId)
      table = tables.find (table) ->
        table.get('id') == tableId
      if not table
        table = fromJS
          id: tableId
          name: dbName
          export: isExported
      else
        table = table.set('name', dbName)
        table = table.set('export', isExported)
      tables = tables.map (t) ->
        if t.get('id') == tableId
          return t = table
        return t
      _store = _store.setIn ['tables', componentId, configId], tables
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_GET_CONFIGURATION_SUCCESS
      componentId = action.componentId
      configId = action.configId
      credentials = action.config.credentials
      tables = action.config.tables
      _store = _store.setIn ['tables',      componentId, configId], fromJS(tables)
      _store = _store.setIn ['credentials', componentId, configId], fromJS(credentials)
      WrDbStore.emitChange()

    when constants.ActionTypes.WR_DB_API_ERROR
      componentId = action.componentId
      configId = action.configId
      path = action.errorPath
      if path
        _store = _store.deleteIn path
      WrDbStore.emitChange()


module.exports = WrDbStore
