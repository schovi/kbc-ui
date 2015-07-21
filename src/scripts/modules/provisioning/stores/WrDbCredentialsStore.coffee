Dispatcher = require '../../../Dispatcher'
{Map, fromJS} = require 'immutable'
storeUtils = require '../../../utils/StoreUtils'
constants = require '../Constants'

_store = Map
  credentials: Map()
  loadingCredentials: Map()
  creatingCredentials: Map()
  droppingCredentials: Map()


provisioningStore = storeUtils.createStore

  getCredentials: (type, token) ->
    _store.getIn ['credentials', type, token]

  isLoadingredentials: (type, token) ->
    _store.hasIn ['loadingCredentials', type, token]

  getIsLoaded: (type, token) ->
    _store.hasIn ['credentials', type, token]



Dispatcher.register (payload) ->
  action = payload.action
  switch action.type
    when constants.ActionTypes.WR_DB_PROVISIONING_GET_CREDENTIALS_SUCCESS
      credentials = fromJS action.credentials
      token = action.token
      permission = action.permission
      _store = _store.setIn ['credentials', permission, token], credentials
      provisioningStore.emitChange()


    when constants.ActionTypes.CREDENTIALS_WRDB_LOAD
      token = action.token
      permission = action.permission
      _store = _store.setIn ['loadingCredentials', permission, token], true
      provisioningStore.emitChange()

    when constants.ActionTypes.CREDENTIALS_WRDB_LOAD_SUCCESS
      token = action.token
      permission = action.permission
      credentials = fromJS action.credentials
      _store = _store.deleteIn ['loadingCredentials', permission, token]
      _store = _store.setIn ['credentials', permission, token], credentials
      provisioningStore.emitChange()


    when constants.ActionTypes.CREDENTIALS_WRDB_LOAD_ERROR
      token = action.token
      permission = action.permission
      _store = _store.deleteIn ['loadingCredentials', permission, token]
      provisioningStore.emitChange()

    when constants.ActionTypes.CREDENTIALS_WRDB_CREATE
      token = action.token
      permission = action.permission
      _store = _store.setIn ['creatingCredentials', permission, token], true
      provisioningStore.emitChange()

    when constants.ActionTypes.CREDENTIALS_WRDB_CREATE_SUCCESS
      token = action.token
      permission = action.permission
      credentials = action.credentials
      _store = _store.deleteIn ['creatingCredentials', permission, token]
      _store = _store.setIn ['credentials', permission, token], credentials
      provisioningStore.emitChange()

    when constants.ActionTypes.CREDENTIALS_WRDB_CREATE_ERROR
      token = action.token
      permission = action.permission
      _store = _store.deleteIn ['creatingCredentials', permission, token], true
      provisioningStore.emitChange()

    when constants.ActionTypes.CREDENTIALS_WRDB_DROP
      token = action.token
      permission = action.permission
      _store = _store.setIn ['droppingCredentials', permission, token], true
      provisioningStore.emitChange()

    when constants.ActionTypes.CREDENTIALS_WRDB_DROP_SUCCESS
      token = action.token
      permission = action.permission
      _store = _store.deleteIn ['credentials', permission, token]
      _store = _store.deleteIn ['droppingCredentials', permission, token]
      provisioningStore.emitChange()

    when constants.ActionTypes.CREDENTIALS_WRDB_DROP_ERROR
      token = action.token
      permission = action.permission
      _store = _store.deleteIn ['droppingCredentials', permission, token]
      provisioningStore.emitChange()

module.exports = provisioningStore
