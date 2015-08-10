{Map, List, fromJS} = require 'immutable'
storeUtils = require '../../utils/StoreUtils'
Dispatcher = require('../../Dispatcher')
{ActionTypes} = require('./constants')
_store = Map
  files: Map() #configId#tableId
  loading: Map() #what #configId #tableID
  googleInfo: Map() #configId#googleId
  editing: Map()
  updating: Map() #what# configId
  deleting: Map() #configId#tableID
  accounts: Map() #configId

WrGdriveStore = storeUtils.createStore
  getFiles: (configId) ->
    _store.getIn ['files', configId]

  getLoadingGoogleInfo: (configId, googleId) ->
    _store.getIn ['loading', 'googleInfo', configId, googleId]

  getGoogleInfo: (configId) ->
    _store.getIn ['googleInfo', configId]

  getEditingByPath: (configId, path) ->
    editPath = ['editing', configId].concat(path)
    _store.getIn editPath

  getEditing: (configId) ->
    _store.getIn(['editing', configId], Map())

  getSavingFiles: (configId) ->
    _store.getIn(['updating','files', configId], Map())

  getDeletingFiles: (configId) ->
    _store.getIn(['deleting', configId], Map())

  getAccount: (configId) ->
    _store.getIn(['accounts', configId])



Dispatcher.register (payload) ->
  action = payload.action
  switch action.type
    when ActionTypes.WR_GDRIVE_LOAD_ACCOUNT_SUCCESS
      configId = action.configId
      data = fromJS action.account
      _store = _store.setIn ['accounts', configId], data
      WrGdriveStore.emitChange()

    when ActionTypes.WR_GDRIVE_DELETE_ROW_START
      configId = action.configId
      tableId = action.tableId
      _store = _store.setIn ['deleting', configId, tableId], true
      WrGdriveStore.emitChange()

    when ActionTypes.WR_GDRIVE_DELETE_ROW_SUCCESS
      configId = action.configId
      tableId = action.tableId
      _store = _store.deleteIn ['deleting', configId, tableId]
      _store = _store.deleteIn ['files', configId, tableId]
      WrGdriveStore.emitChange()

    when ActionTypes.WR_GDRIVE_SAVEFILE_START
      configId = action.configId
      tableId = action.tableId
      _store = _store.setIn ['updating', 'files', configId, tableId], true
      WrGdriveStore.emitChange()

    when ActionTypes.WR_GDRIVE_SAVEFILE_SUCCESS
      configId = action.configId
      tableId = action.tableId
      files = fromJS action.files
      files = files.toMap().mapKeys (index, file) ->
        file.get 'tableId'
      _store = _store.setIn ['files', configId], files
      _store = _store.deleteIn ['updating', 'files', configId, tableId]
      WrGdriveStore.emitChange()

    when ActionTypes.WR_GDRIVE_SET_EDITING
      configId = action.configId
      path = action.path
      data = action.data
      editPath = ['editing', configId].concat(path)
      _store = _store.setIn editPath, data
      WrGdriveStore.emitChange()

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
