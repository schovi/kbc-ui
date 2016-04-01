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
    _store.getIn ['loadingSchemas', componentId], false

  getParamsSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'params'], Map()

  getPureParamsSchema: (componentId) ->
    schema = _store.getIn ['schemas', componentId, 'schemas', 'params'], Map()
    if schema.hasIn ['properties', 'jobs']
      schema = schema.deleteIn ['properties', 'jobs']
    schema

  getJobsSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'params', 'jobs'], Map()

  getJobsTemplates: (componentId) ->
    _store.getIn ['schemas', componentId, 'templates', 'jobs'], Map()

  getApiSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'api'], Map()

  getApiTemplate: (componentId) ->
    _store.getIn ['schemas', componentId, 'templates', 'api'], Map()

  isJobsTemplate: (componentId, jobs) ->
    templates = _store.getIn ['schemas', componentId, 'templates', 'jobs'], Map()
    templates.filter((template) ->
      if (!template.has("jobs"))
        return false
      template.get("jobs").hashCode() == jobs.hashCode()
    ).count() == 1


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
