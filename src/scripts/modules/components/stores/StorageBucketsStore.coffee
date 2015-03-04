
Dispatcher = require('../../../Dispatcher')
constants = require '../Constants'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../../utils/StoreUtils'

_store = Map(
  buckets: Map()
  isLoaded: false
  isLoading: false
)

StorageBucketsStore = StoreUtils.createStore

  getAll: ->
    _store.get 'buckets'

  getIsLoading: ->
    _store.get 'isLoading'

  getIsLoaded: ->
    _store.get 'isLoaded'


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when constants.ActionTypes.STORAGE_BUCKETS_LOAD
      _store = _store.set 'isLoading', true
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKETS_LOAD_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .set 'isLoading', false
        .set 'buckets', action.buckets
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKETS_LOAD_ERROR
      _store = _store.set 'isLoading', false
      StorageBucketsStore.emitChange()


module.exports = StorageBucketsStore
