StoreUtils = require '../../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../../Dispatcher'
Constants = require '../SchemasConstants'
fuzzy = require 'fuzzy'
fromJSOrdered = require('../../../utils/fromJSOrdered').default
deepEqual = require 'deep-equal'

{Map} = Immutable

_store = Map
  loadingSchemas: Map()
  schemas: Map()

SchemasStore = StoreUtils.createStore
  hasSchema: (componentId) ->
    _store.hasIn ['schemas', componentId]

  isLoadingSchema: (componentId) ->
    _store.getIn ['loadingSchemas', componentId], false

  getParamsSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'params'], Map()

  getPureParamsSchema: (componentId) ->
    schema = _store.getIn ['schemas', componentId, 'schemas', 'params'], Map()
    if schema.hasIn ['properties', 'jobs']
      schema = schema.deleteIn ['properties', 'jobs']
    if schema.hasIn ['properties', 'mappings']
      schema = schema.deleteIn ['properties', 'mappings']
    schema

  getJobsSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'params', 'jobs'], Map()

  # new
  getConfigTemplates: (componentId) ->
    _store.getIn ['schemas', componentId, 'templates', 'config'], Map()

  getApiSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'api'], Map()

  getApiTemplate: (componentId) ->
    _store.getIn ['schemas', componentId, 'templates', 'api'], Map()

  isConfigTemplate: (componentId, configuration) ->
    templates = _store.getIn ['schemas', componentId, 'templates', 'config'], Map()
    templates.filter((template) ->
      return deepEqual(template.get("jobs").toJS(), configuration.get("jobs", Immutable.List()).toJS()) &&
          deepEqual(template.get("mappings").toJS(), configuration.get("mappings", Immutable.Map()).toJS())
    ).count() == 1

dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.SCHEMA_LOAD_SUCCESS
      _store = _store.setIn ['schemas', action.componentId], fromJSOrdered(action.schema)
      SchemasStore.emitChange()

    when Constants.ActionTypes.SCHEMA_LOAD_START
      _store = _store.setIn(['loadingSchemas', action.componentId], true)
      SchemasStore.emitChange()

    when Constants.ActionTypes.SCHEMA_LOAD_ERROR
      _store = _store.setIn(['loadingSchemas', action.componentId], false)
      SchemasStore.emitChange()

module.exports = SchemasStore
