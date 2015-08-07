Dispatcher = require('../../../Dispatcher')
constants = require '../Constants'
Immutable = require('immutable')
{Map, List} = Immutable
StoreUtils = require '../../../utils/StoreUtils'
_ = require 'underscore'

_store = Map(
  tokens: List()
  isLoaded: false
  isLoading: false
)

StorageTokensStore = StoreUtils.createStore

  getAll: ->
    _store.get 'tokens'

  getIsLoading: ->
    _store.get 'isLoading'

  getIsLoaded: ->
    _store.get 'isLoaded'


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when constants.ActionTypes.STORAGE_TOKEN_CREATE_SUCCESS
      token = Immutable.fromJS(action.token)
      tokens = _store.get('tokens', List())
      _store = _store.set('tokens', tokens.push(token))
      StorageTokensStore.emitChange()

    when constants.ActionTypes.STORAGE_TOKENS_LOAD
      _store = _store.set 'isLoading', true
      StorageTokensStore.emitChange()

    when constants.ActionTypes.STORAGE_TOKENS_LOAD_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .set 'tokens', Immutable.fromJS action.tokens
        .set 'isLoading', false
        .set 'isLoaded', true
      StorageTokensStore.emitChange()

    when constants.ActionTypes.STORAGE_TOKENS_LOAD_ERROR
      _store = _store.set 'isLoading', false
      StorageTokensStore.emitChange()


module.exports = StorageTokensStore
