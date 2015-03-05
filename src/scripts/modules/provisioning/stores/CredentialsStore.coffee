Immutable = require('immutable')
StoreUtils = require('../../../utils/StoreUtils')
Constants = require('../Constants')
Dispatcher = require '../../../Dispatcher'
_ = require('underscore')

Map = Immutable.Map
List = Immutable.List

_store = Map(
  credentialsById: Map()
)

CredentialsStore = StoreUtils.createStore
  get: (id) ->
    _store.getIn ['credentialsById', id]

  has: (id) ->
    _store.hasIn ['credentialsById', id]

  getByBackendAndType: (backend, credentialsType) ->
    result = _store.get("credentialsById").find (value) ->
      value.get('backend') == backend and value.get('credentialsType') == credentialsType
    return result

  hasByBackendAndType: (backend, credentialsType) ->
    !!@getByBackendAndType(backend, credentialsType)

Dispatcher.register (payload) ->
  action = payload.action
  switch action.type
    when Constants.ActionTypes.CREDENTIALS_LOAD_SUCCESS
      credentials = Immutable.fromJS(action.credentials)
      if (credentials.getIn ['credentials', 'id'])
        _store = _store.setIn ['credentialsById', credentials.getIn(['credentials', 'id'])], credentials
        CredentialsStore.emitChange()

    when Constants.ActionTypes.CREDENTIALS_CREATE_SUCCESS
      credentials = Immutable.fromJS(action.credentials)
      _store = _store.setIn ['credentialsById', credentials.getIn(['credentials', 'id'])], credentials
      CredentialsStore.emitChange()

    when Constants.ActionTypes.CREDENTIALS_DROP_SUCCESS
      _store = _store.deleteIn ['credentialsById', action.credentialsId]
      CredentialsStore.emitChange()

module.exports = CredentialsStore
