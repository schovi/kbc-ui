Dispatcher = require('../../../Dispatcher')
constants = require '../Constants'
Immutable = require('immutable')
{Map, List} = Immutable
StoreUtils = require '../../../utils/StoreUtils'
_ = require 'underscore'

_store = Map(
  files: List()
  isLoaded: false
  isLoading: false
)

StorageFilesStore = StoreUtils.createStore

  getAll: ->
    _store.get 'files'

  getIsLoading: ->
    _store.get 'isLoading'

  getIsLoaded: ->
    _store.get 'isLoaded'


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when constants.ActionTypes.STORAGE_FILES_LOAD
      _store = _store.set 'isLoading', true
      StorageFilesStore.emitChange()

    when constants.ActionTypes.STORAGE_FILES_LOAD_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .set 'files', Immutable.fromJS action.files
        .set 'isLoading', false
        .set 'isLoaded', true
      StorageFilesStore.emitChange()

    when constants.ActionTypes.STORAGE_FILES_LOAD_ERROR
      _store = _store.set 'isLoading', false
      StorageFilesStore.emitChange()


module.exports = StorageFilesStore
