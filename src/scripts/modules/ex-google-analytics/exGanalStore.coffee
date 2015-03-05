Dispatcher = require('../../Dispatcher')
Immutable = require('immutable')
Map = Immutable.Map
List = Immutable.List
StoreUtils = require('../../utils/StoreUtils')
Constants = require './exGanalConstants'
_ = require 'underscore'
_store = Map(
  configs: Map() #config by configId
  newQuery: Map() #configId
  savingNewQuery: Map() #configId
  validation: Map()
  editing: Map() #configId name query
  saving: Map() #configId name query
)


GanalStore = StoreUtils.createStore
  isQueryInvalid: (configId, name) ->
    val = _store.getIn ['validation', configId, name]
    val and val.count() > 0
  isEditingQuery: (configId, name) ->
    _store.hasIn ['editing', configId, name]
  isSavingQuery: (configId, name) ->
    _store.hasIn ['saving', configId, name]
  getQueryValidation: (configId, name) ->
    _store.getIn ['validation', configId, name]
  getEditingQuery: (configId, name) ->
    _store.getIn ['editing', configId, name]
  getQuery: (configId, name) ->
    _store.getIn ['configs', configId, 'configuration', name]


  isNewQueryInvalid: (configId) ->
    val = _store.getIn ['validation', configId, '--newquery--']
    val and val.count() > 0
  getNewQueryValidation: (configId) ->
    _store.getIn ['validation', configId, '--newquery--']
  hasConfig: (configId)  ->
    _store.hasIn ['configs', configId]
  getConfig: (configId) ->
    _store.getIn(['configs', configId])
  isSavingNewQuery: (configId) ->
    _store.hasIn ['savingNewQuery', configId]
  getConfigToSave: (configId) ->
    _store.getIn ['savingNewQuery', configId]
  getNewQuery: (configId) ->
    if _store.hasIn ['newQuery', configId]
      return _store.getIn ['newQuery', configId]
    newQuery = Immutable.fromJS
      name: ""
      metrics: []
      dimensions: []
      filters: ""
      profile: ""

    _store.setIn ['newQuery', configId], newQuery
    return newQuery


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.EX_GANAL_QUERY_TOOGLE_EDITING
      configId = action.configId
      name = action.name
      initQuery = action.initQuery
      filters = initQuery.get 'filters'
      if filters and List.isList(filters)
        initQuery = initQuery.set 'filters', filters.get(0)
      initQuery = initQuery.set 'name', name
      _store = _store.setIn ['editing', configId, name], initQuery
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_CHANGE_QUERY
      configId = action.configId
      name = action.name
      newQuery = action.newQuery
      _store = _store.setIn ['editing', configId, name], newQuery
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_CONFIGURATION_LOAD_SUCCEES
      configId = action.configId
      data = Immutable.fromJS(action.data)
      _store = _store.setIn(['configs', configId], data)
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_CHANGE_NEW_QUERY
      configId = action.configId
      newQuery = action.newQuery
      queries = GanalStore.getConfig(configId).get('configuration').toJS()
      queryName = newQuery.get('name')
      validation = {}
      emptyArrayCheck = (what) ->
        if newQuery.get(what).count() == 0
          validation[what] = 'Can not be empty.'
      emptyArrayCheck('metrics')
      emptyArrayCheck('dimensions')

      if _.isEmpty(queryName)
        validation.name = 'Can not be empty.'
      else
        if queryName in _.keys(queries)
          validation.name = 'Query with that name already exists.'
      _store = _store.setIn ['validation',configId, '--newquery--'], Immutable.fromJS validation


      _store = _store.setIn ['newQuery', configId], action.newQuery
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_NEW_QUERY_RESET
      configId = action.configId
      _store = _store.deleteIn ['newQuery', configId]
      _store = _store.deleteIn ['validation', configId, '--newquery--']
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_NEW_QUERY_CREATE_START
      configId = action.configId
      newQuery = _store.getIn ['newQuery', configId]
      newQueryName = newQuery.get 'name'
      filters = newQuery.get('filters')
      #ga ex api is retarded so is following statement
      if filters and not _.isArray filters
        newQuery = newQuery.set 'filters', [filters]
      config = GanalStore.getConfig(configId).get 'configuration'
      config = config.set(newQueryName, newQuery)
      _store = _store.setIn ['savingNewQuery', configId], config
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_NEW_QUERY_CREATE_SUCCESS
      configId = action.configId
      newConfig = action.newConfig
      _store = _store.setIn ['configs', configId], Immutable.fromJS(newConfig)
      _store = _store.deleteIn ['savingNewQuery', configId]
      _store = _store.deleteIn ['newQuery', configId]
      GanalStore.emitChange()


module.exports = GanalStore
