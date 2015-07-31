{Map, List, fromJS} = require 'immutable'
storeUtils = require '../../utils/StoreUtils'
Dispatcher = require('../../Dispatcher')
{ActionTypes} = require('./constants')
_store = Map
  files: Map() #configId#tableId
  loading: Map() #what #configId #tableID
  googleInfo: Map() #configId#googleId

WrGdriveStore = storeUtils.createStore
  getFiles: (configId) ->
    _store.getIn ['files', configId]

  getLoadingGoogleInfo: (configId, googleId) ->
    _store.getIn ['loading', 'googleInfo', configId, googleId]

  getGoogleInfo: (configId) ->
    _store.getIn ['googleInfo', configId]


Dispatcher.register (payload) ->
  action = payload.action
  switch action.type
    when ActionTypes.WR_GDRIVE_LOAD_FILES_SUCCESS
      files = fromJS action.files
      configId = action.configId
      files = files.toMap().mapKeys (index, file) ->
        file.get 'tableId'
      _store = _store.setIn ['files', configId], files
      WrGdriveStore.emitChange()

    when ActionTypes.WR_GDRIVE_LOAD_GOOGLEINFO_START

      googleId = action.googleId
      configId = action.configId

      _store = _store.setIn ['loading', 'googleInfo', configId, googleId], true
      WrGdriveStore.emitChange()

    when ActionTypes.WR_GDRIVE_LOAD_GOOGLEINFO_SUCCESS
      googleId = action.googleId
      configId = action.configId
      googleInfo = fromJS action.googleInfo
      _store = _store.deleteIn ['loading', 'googleInfo', configId, googleId]
      _store = _store.setIn ['googleInfo', configId, googleId], googleInfo
      WrGdriveStore.emitChange()



module.exports = WrGdriveStore
