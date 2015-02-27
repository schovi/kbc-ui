
StoreUtils = require '../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../Dispatcher'
constants = require './constants'

{Map, List} = Immutable


_store = Map
  writers: Map()
  tables: Map()
  tableColumns: Map()

GoodDataWriterStore = StoreUtils.createStore


  hasWriter: (configurationId) ->
    _store.hasIn ['writers', configurationId]

  hasTableColumns: (configurationId, tableId) ->
    _store.hasIn ['tableColumns', configurationId, tableId, 'current']

  getWriter: (configurationId) ->
    _store.getIn ['writers', configurationId]

  getWriterTablesByBucket: (configurationId) ->
    _store
    .getIn(['tables', configurationId])
    .toSeq()
    .groupBy (table) ->
      table.getIn ['data', 'bucket']

  getTable: (configurationId, tableId) ->
    _store.getIn ['tables', configurationId, tableId]

  getTableColumns: (configurationId, tableId, version = 'current') ->
    _store.getIn ['tableColumns', configurationId, tableId, version]

  isEditingTableColumns: (configurationId, tableId) ->
    _store.hasIn ['tableColumns', configurationId, tableId, 'editing']

dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_START
      _store = _store.setIn ['writers', action.configurationId, 'isLoading'], true
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_ERROR
      _store = _store.setIn ['writers', action.configurationId, 'isLoading'], false
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_SUCCESS
      tablesById = Immutable
      .fromJS(action.configuration.tables)
      .toMap()
      .map (table) ->
        Map
          isLoading: false
          id: table.get 'id'
          pendingActions: List()
          data: table
      .mapKeys (key, table) ->
        table.get 'id'

      _store = _store.withMutations (store) ->
        store
        .setIn ['writers', action.configuration.id, 'isLoading'], false
        .setIn ['writers', action.configuration.id, 'config'], Immutable.fromJS action.configuration.writer
        .setIn ['tables', action.configuration.id], tablesById
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_TABLE_EXPORT_STATUS_CHANGE_START
      _store = _store.updateIn ['tables', action.configurationId, action.tableId, 'pendingActions'], (actions) ->
        actions.push 'exportStatusChange'
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_TABLE_EXPORT_STATUS_CHANGE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .setIn ['tables', action.configurationId, action.tableId, 'data', 'export'], action.newExportStatus
        .updateIn ['tables', action.configurationId, action.tableId, 'pendingActions'], (actions) ->
          actions.delete(actions.indexOf 'exportStatusChange')
      console.log 'store', _store.toJS()
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_TABLE_EXPORT_STATUS_CHANGE_ERROR
      _store = _store.updateIn ['tables', action.configurationId, action.tableId, 'pendingActions'], (actions) ->
        actions.delete(actions.indexOf 'exportStatusChange')
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_TABLE_SUCCESS
      table = Immutable.fromJS(action.table)
        .set 'bucket', action.table.id.split('.',2).join('.') # bucket is not returned by api

      columns = table.get('columns').toMap().mapKeys (key, column) ->
        column.get 'name'

      _store = _store.withMutations (store) ->
        store
        .setIn ['tables', action.configurationId, table.get('id'), 'data'], table.remove('columns')
        .setIn ['tableColumns', action.configurationId, table.get('id'), 'current'], columns
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_START
      _store = _store.setIn ['tableColumns', action.configurationId, action.tableId, 'editing'],
        _store.getIn ['tableColumns', action.configurationId, action.tableId, 'current']
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_CANCEL
      _store = _store.deleteIn ['tableColumns', action.configurationId, action.tableId, 'editing']
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_UPDATE
      _store = _store.setIn [
        'tableColumns'
        action.configurationId
        action.tableId
        'editing'
        action.column.get 'name'
      ], action.column
      GoodDataWriterStore.emitChange()

module.exports = GoodDataWriterStore