StoreUtils = require '../../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../../Dispatcher'
Constants = require '../SchemasConstants'
fuzzy = require 'fuzzy'

{Map, List} = Immutable

_store = Map
  loadingSchemas: Map()
  schemas: Map()

SchemasStore = StoreUtils.createStore
  hasSchema: (componentId) ->
    _store.hasIn ['schemas', componentId]

  isLoadingSchema: (componentId) ->
    if (@isLoadingManifest())
      return true
    _store.getIn ['loadingSchemas', componentId], false

  getParamsSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'params'], Map()

  getApiSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'api'], Map()

  getApiTemplate: (componentId) ->
    _store.getIn ['schemas', componentId, 'templates', 'api'], Map()

dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.SCHEMA_LOAD_SUCCESS
      _store = _store.setIn ['schemas', action.componentId], Immutable.fromJS(action.schema)
      SchemasStore.emitChange()

    when Constants.ActionTypes.SCHEMA_LOAD_START
      _store = _store.setIn(['loadingSchemas', action.componentId], true)
      SchemasStore.emitChange()

    when Constants.ActionTypes.SCHEMA_LOAD_ERROR
      _store = _store.setIn(['loadingSchemas', action.componentId], false)
      SchemasStore.emitChange()

module.exports = SchemasStore
