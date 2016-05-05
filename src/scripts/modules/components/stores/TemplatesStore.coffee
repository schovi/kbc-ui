StoreUtils = require '../../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../../Dispatcher'
Constants = require '../TemplatesConstants'
fuzzy = require 'fuzzy'
fromJSOrdered = require('../../../utils/fromJSOrdered').default
templateFinder = require '../utils/templateFinder'

{Map} = Immutable

_store = Map
  loadingTemplates: Map()
  templates: Map()

TemplatesStore = StoreUtils.createStore
  hasTemplates: (componentId) ->
    _store.hasIn ['templates', componentId]

  # TODO -> installedcomponentsstore
  getParamsSchema: (componentId) ->
    _store.getIn ['templates', componentId, 'templates', 'params'], Map()

  # TODO -> installedcomponentsstore
  getPureParamsSchema: (componentId) ->
    schema = _store.getIn ['templates', componentId, 'templates', 'params'], Map()
    if schema.hasIn ['properties', 'jobs']
      schema = schema.deleteIn ['properties', 'jobs']
    if schema.hasIn ['properties', 'mappings']
      schema = schema.deleteIn ['properties', 'mappings']
    schema

  # new
  getConfigTemplates: (componentId) ->
    _store.getIn ['templates', componentId, 'templates', 'config'], Map()

  getApiTemplate: (componentId) ->
    _store.getIn ['templates', componentId, 'templates', 'api'], Map()

  isConfigTemplate: (componentId, configuration) ->
    templates = _store.getIn ['templates', componentId, 'templates', 'config'], Map()
    templateFinder(templates, configuration).count() == 1

  getMatchingTemplate: (componentId, configuration) ->
    templates = _store.getIn(['templates', componentId, 'templates', 'config'], Map())
    if templates.isEmpty()
      return Immutable.Map()
    match = templateFinder(templates, configuration)
    if (match.count() == 1)
      return match.first()
    return Immutable.Map()

dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.TEMPLATES_LOAD_SUCCESS
      _store = _store.setIn ['templates', action.componentId], fromJSOrdered(action.templates)
      TemplatesStore.emitChange()

    when Constants.ActionTypes.TEMPLATES_LOAD_START
      _store = _store.setIn(['loadingTemplates', action.componentId], true)
      TemplatesStore.emitChange()

    when Constants.ActionTypes.TEMPLATES_LOAD_ERROR
      _store = _store.setIn(['loadingTemplates', action.componentId], false)
      TemplatesStore.emitChange()

module.exports = TemplatesStore
