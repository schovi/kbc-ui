{Map, List, fromJS} = require 'immutable'
storeUtils = require '../../utils/StoreUtils'
Dispatcher = require('../../Dispatcher')
{ActionTypes} = require('./constants')
_store = Map
  files: Map() #configId#tableId
  loading: Map() #what #configId #tableID
  googleInfo: Map() #email#googleId

WrGdriveStore = storeUtils.createStore
  getFiles: (configId) ->
    _store.getIn ['files', configId]

  getLoadingGoogleInfo: (email, googleId) ->
    _store.getIn ['loading', 'googleInfo', email, googleId]

  getGoogleInfo: (email) ->
    _store.getIn ['googleInfo', email]


Dispatcher.register (payload) ->
  action = payload.action
  console.log 'ACTION', action.type
  switch action.type
    when ActionTypes.WR_GDRIVE_LOAD_FILES_SUCCESS
      files = fromJS action.files
      configId = action.configId
      console.log 'fileees', files
      files = files.toMap().mapKeys (index, file) ->
        file.get 'tableId'
      _store = _store.setIn ['files', configId], files
      WrGdriveStore.emitChange()

    when ActionTypes.WR_GDRIVE_LOAD_GOOGLEINFO_START
      console.log 'TUUUUUUUUUUUUUUUUUU'
      googleId = action.googleId
      email = action.email
      console.log 'setting STAAART', email, googleId
      _store = _store.setIn ['loading', 'googleInfo', email, googleId], true
      WrGdriveStore.emitChange()

    when ActionTypes.WR_GDRIVE_LOAD_GOOGLEINFO_SUCCESS
      googleId = action.googleId
      email = action.email
      google = action.google
      _store = _store.deleteIn ['loading', 'googleInfo', email, googleId]
      _store = _store.setIn ['googleInfo', email, googleId], google
      WrGdriveStore.emitChange()



module.exports = WrGdriveStore
