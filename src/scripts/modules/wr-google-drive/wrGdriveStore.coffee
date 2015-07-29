{Map, List, fromJS} = require 'immutable'
storeUtils = require '../../utils/StoreUtils'
Dispatcher = require('../../Dispatcher')
{ActionTypes} = require('./constants')
_store = Map
  files: Map() #configId#tableId
  loading: Map() #configId #tableID


WrGdriveStore = storeUtils.createStore
  getFiles: (configId) ->
    _store.getIn ['files', configId]


Dispatcher.register (payload) ->
  action = payload.action
  switch action.type
    when ActionTypes.WR_GDRIVE_LOAD_FILES_SUCCESS
      files = fromJS action.files
      configId = action.configId
      console.log 'fileees', files
      files = files.toMap().mapKeys (index, file) ->
        file.get 'tableId'
      _store = _store.setIn ['files', configId], files
      WrGdriveStore.emitChange()



module.exports = WrGdriveStore
