
Dispatcher = require('../../../Dispatcher')
constants = require '../Constants'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../../utils/StoreUtils'
_ = require 'underscore'

_store = Map(
  tables: Map()
  isLoaded: false
  isLoading: false
  pendingTables: Map() #(creating/loading)
)

StorageTablesStore = StoreUtils.createStore

  getAll: ->
    _store.get 'tables'
    
  hasTable: (tableId) ->
    _store.get('tables').has(tableId)

  getIsLoading: ->
    _store.get 'isLoading'

  getIsLoaded: ->
    _store.get 'isLoaded'
    
  getIsCreatingTable: ->
    _store.getIn ['pendingTables', 'creating'], false
    
  getIsLoadingTable: ->
    _store.getIn ['pendingTables', 'loading'], false

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when constants.ActionTypes.STORAGE_TABLES_LOAD
      _store = _store.set 'isLoading', true
      StorageTablesStore.emitChange()

    when constants.ActionTypes.STORAGE_TABLES_LOAD_SUCCESS
      _store = _store.withMutations (store) ->
        store = store.setIn ['tables'], Map()
        _.each(action.tables, (table) ->
          tObj = Immutable.fromJS(table)
          store = store.setIn ['tables', tObj.get 'id'], tObj
        )
        store
          .set 'isLoading', false
          .set 'isLoaded', true
      StorageTablesStore.emitChange()

    when constants.ActionTypes.STORAGE_TABLES_LOAD_ERROR
      _store = _store.set 'isLoading', false
      StorageTablesStore.emitChange()

    when constants.ActionTypes.STORAGE_TABLES_CREATE
      _store = _store.setIn ['pendingTables', 'creating'], true
      StorageTablesStore.emitChange()

    when constants.ActionTypes.STORAGE_TABLE_CREATE_SUCCESS
      _store = _store.setIn ['pendingTables', 'creating'], false
      _store = _store.setIn ['tables', action.table.id], Immutable.fromJS(action.table)
      console.log(_store.getIn(['tables']).toJS())
      StorageTablesStore.emitChange()

    when constants.ActionTypes.STORAGE_TABLE_CREATE_ERROR
      _store = _store.setIn ['pendingTables', 'creating'], false
      StorageTablesStore.emitChange()

    when constants.ActionTypes.STORAGE_TABLES_LOAD
      _store = _store.setIn ['pendingTables', 'loading'], true
      StorageTablesStore.emitChange()

    when constants.ActionTypes.STORAGE_TABLE_LOAD_SUCCESS
      _store = _store.setIn ['pendingTables', 'loading'], false
      StorageTablesStore.emitChange()

    when constants.ActionTypes.STORAGE_TABLE_LOAD_ERROR
      _store = _store.setIn ['pendingTables', 'loading'], false
      StorageTablesStore.emitChange()

module.exports = StorageTablesStore
