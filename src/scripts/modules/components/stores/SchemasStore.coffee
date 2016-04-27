StoreUtils = require '../../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../../Dispatcher'
Constants = require '../SchemasConstants'
fuzzy = require 'fuzzy'
fromJSOrdered = require('../../../utils/fromJSOrdered').default
getTemplatedConfigHashCode = require('../utils/getTemplatedConfigHashCode').default

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
    if schema.hasIn ['properties', 'mappings']
      schema = schema.deleteIn ['properties', 'mappings']
    schema

  getJobsSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'params', 'jobs'], Map()

  # DEPRECATED
  getJobsTemplates: (componentId) ->
    _store.getIn ['schemas', componentId, 'templates', 'jobs'], Map()

  # new
  getConfigTemplates: (componentId) ->
    _store.getIn ['schemas', componentId, 'templates', 'config'], Map()

  getApiSchema: (componentId) ->
    _store.getIn ['schemas', componentId, 'schemas', 'api'], Map()

  getApiTemplate: (componentId) ->
    _store.getIn ['schemas', componentId, 'templates', 'api'], Map()

  isConfigTemplate: (componentId, configuration) ->
    templates = _store.getIn ['schemas', componentId, 'templates', 'config'], Map()
    configHashCode = getTemplatedConfigHashCode(configuration)
    console.log("configHashCode", configHashCode)
    templates.filter((template) ->
      templateHashCode = getTemplatedConfigHashCode(template)
      console.log("templateHashCode", templateHashCode)
      return templateHashCode == configHashCode
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
