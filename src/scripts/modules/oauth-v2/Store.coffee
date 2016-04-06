StoreUtils = require '../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../Dispatcher'
Constants = require './Constants'
fuzzy = require 'fuzzy'

{Map, List} = Immutable


_store = Map
  deletingCredentials: Map()
  credentials: Map()

OAuthStore = StoreUtils.createStore
  hasCredentials: (componentId, id) ->
    _store.hasIn ['credentials', componentId, id]

  getCredentials: (componentId, id) ->
    _store.getIn ['credentials', componentId, id]

  isDeletingCredetials: (componentId, id) ->
    _store.hasIn ['deletingCredentials', componentId, id]


dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.OAUTHV2_LOAD_CREDENTIALS_SUCCESS
      credentials = action.credentials
      _store = _store.setIn ['credentials', action.componentId, action.id], credentials
      OAuthStore.emitChange()

    when Constants.ActionTypes.OAUTHV2_DELETE_CREDENTIALS_START
      _store = _store.setIn(['deletingCredentials', action.componentId, action.id], true)
      OAuthStore.emitChange()

    when Constants.ActionTypes.OAUTHV2_DELETE_CREDENTIALS_SUCCESS
      _store = _store.deleteIn ['deletingCredentials', action.componentId, action.id]
      _store = _store.deleteIn ['credentials', action.componentId, action.id]
      OAuthStore.emitChange()

    when Constants.ActionTypes.OAUTHV2_API_ERROR
      _store = _store.deleteIn ['deletingCredentials', action.componentId, action.id]
      OAuthStore.emitChange()

module.exports = OAuthStore
