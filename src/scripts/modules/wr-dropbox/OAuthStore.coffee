StoreUtils = require '../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../Dispatcher'
Constants = require './OAuthConstants'
fuzzy = require 'fuzzy'

{Map, List} = Immutable


_store = Map
  deleteingCredentials: Map()
  credentials: Map()

OAuthStore = StoreUtils.createStore
  hasCredentials: (componentId, configId) ->
    _store.hasIn ['credentials', componentId, configId]

  getCredentials: (componentId, configId) ->
    _store.getIn ['credentials', componentId, configId]

  isDeletingCredetials: (componentId, configId) ->
    _store.hasIn ['deleteingCredentials', componentId, configId]


dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.OAUTH_LOAD_CREDENTIALS_SUCCESS
      credentials = action.credentials
      _store = _store.setIn ['credentials', action.componentId, action.configId], credentials
      OAuthStore.emitChange()

    when Constants.ActionTypes.OAUTH_DELETE_CREDENTIALS_START
      _store = _store.setIn ['deletingCredentials', action.componentId, action.configId], true
      OAuthStore.emitChange()

    when Constants.ActionTypes.OAUTH_DELETE_CREDENTIALS_SUCCESS
      _store = _store.deleteIn ['deletingCredentials', action.componentId, action.configId]
      _store = _store.deleteIn ['credentials', action.componentId, action.configId]
      OAuthStore.emitChange()

    when Constants.ActionTypes.OAUTH_API_ERROR
      _store = _store.deleteIn ['deletingCredentials', action.componentId, action.configId]
      OAuthStore.emitChange()

module.exports = OAuthStore
