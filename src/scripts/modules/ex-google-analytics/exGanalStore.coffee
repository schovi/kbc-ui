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
  savingConfig: Map() #configId
  validation: Map()
  editing: Map() #configId name query
  saving: Map() #configId name query
  extLinksGenerating: Map() #configId
  extLinks: Map() #configId
  profiles: Map() #confiId
  selectedProfiles: Map() #configId
)


GanalStore = StoreUtils.createStore
  getSelectedProfiles: (configId) ->
    _store.getIn ['selectedProfiles', configId]

  hasProfiles: (configId) ->
    _store.hasIn ['profiles', configId]
  getProfiles: (configId) ->
    _store.getIn ['profiles', configId]
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
  getExtLink: (configId) ->
    _store.getIn ['extLinks', configId]
  isGeneratingExtLink: (configId) ->
    _store.hasIn ['extLinksGenerating', configId]

  isNewQueryInvalid: (configId) ->
    val = _store.getIn ['validation', configId, '--newquery--']
    val and val.count() > 0
  getNewQueryValidation: (configId) ->
    _store.getIn ['validation', configId, '--newquery--']
  hasConfig: (configId)  ->
    _store.hasIn ['configs', configId]
  getConfig: (configId) ->
    _store.getIn(['configs', configId])
  isSavingConfig: (configId) ->
    _store.hasIn ['savingConfig', configId]
  getConfigToSave: (configId) ->
    _store.getIn ['savingConfig', configId]
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

    when Constants.ActionTypes.EX_GANAL_PROFILES_LOAD_SUCCESS
      configId = action.configId
      profiles = Immutable.fromJS action.profiles
      _store = _store.setIn ['profiles', configId], profiles
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_SELECT_PROFILE
      configId = action.configId
      profile = action.profile
      _store = _store.setIn ['selectedProfiles', configId, profile.get 'id'], profile
      GanalStore.emitChange()
    when Constants.ActionTypes.EX_GANAL_DESELECT_PROFILE
      configId = action.configId
      profile = action.profile
      _store = _store.deleteIn ['selectedProfiles', configId, profile.get 'id']
      GanalStore.emitChange()

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

    when Constants.ActionTypes.EX_GANAL_QUERY_RESET
      configId = action.configId
      name = action.name
      _store = _store.deleteIn ['editing', configId, name]
      _store = _store.deleteIn ['validation', configId, name]
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_QUERY_SAVE_START
      configId = action.configId
      name = action.name
      queryToSave = GanalStore.getEditingQuery(configId, name)
      #transform filters to array due to ga ex API being retarded
      setFilters = (query) ->
        filters = query.get 'filters'
        if filters and not List.isList(filters)
          query = query.set('filters', [filters])
        query
      config = GanalStore.getConfig(configId).get('configuration')
      #if name has changed
      if name != queryToSave.get 'name'
        #delete the old one
        config = config.filter (query, qname) ->
          qname != name
        queryToSave = setFilters(queryToSave)
        #set new with new name
        config = config.set queryToSave.get('name'), queryToSave
      else
        #we update with the existing name
        config = config.map((query, qname) ->
          if qname != name
            return query
          queryToSave = setFilters(queryToSave)
          queryToSave
        )
      _store = _store.setIn ['savingConfig', configId], config
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_QUERY_SAVE_SUCCESS
      configId = action.configId
      name = action.name
      newConfig = action.newConfig
      _store = _store.deleteIn ['editing', configId, name]
      _store = _store.deleteIn ['savingConfig', configId]
      _store = _store.setIn ['configs', configId], Immutable.fromJS(newConfig)
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_CHANGE_QUERY
      configId = action.configId
      name = action.name
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
        if queryName in _.keys(queries) and queryName != name
          validation.name = 'Query with that name already exists.'
      _store = _store.setIn ['validation',configId, name], Immutable.fromJS validation


      _store = _store.setIn ['editing', configId, name], newQuery

      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_CONFIGURATION_LOAD_SUCCEES
      configId = action.configId
      data = Immutable.fromJS(action.data)
      _store = _store.setIn(['configs', configId], data)
      if data.has('items') and data.get('items').count() > 0
        _store = _store.setIn(['selectedProfiles', configId], data.get 'items')
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
      _store = _store.setIn ['savingConfig', configId], config
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_NEW_QUERY_CREATE_SUCCESS
      configId = action.configId
      newConfig = action.newConfig
      _store = _store.setIn ['configs', configId], Immutable.fromJS(newConfig)
      _store = _store.deleteIn ['savingConfig', configId]
      _store = _store.deleteIn ['newQuery', configId]
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_GENERATE_EXT_LINK_START
      configId = action.configId
      _store = _store.deleteIn ['extLinks', configId]
      _store = _store.setIn ['extLinksGenerating', configId], true
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_GENERATE_EXT_LINK_END
      configId = action.configId
      extLink = Immutable.fromJS(action.extLink)
      _store = _store.deleteIn ['extLinksGenerating', configId]
      _store = _store.setIn ['extLinks', configId], extLink
      GanalStore.emitChange()

module.exports = GanalStore
