
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
)

StorageTablesStore = StoreUtils.createStore

  getAll: ->
    _store.get 'tables'

  getIsLoading: ->
    _store.get 'isLoading'

  getIsLoaded: ->
    _store.get 'isLoaded'


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
        store.set 'isLoading', false
      StorageTablesStore.emitChange()

    when constants.ActionTypes.STORAGE_TABLES_LOAD_ERROR
      _store = _store.set 'isLoading', false
      StorageTablesStore.emitChange()


module.exports = StorageTablesStore
