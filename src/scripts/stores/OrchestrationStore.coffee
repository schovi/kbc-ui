
Dispatcher = require '../dispatcher/KbcDispatcher.coffee'
Immutable = require('immutable')
Constants = require '../constants/KbcConstants.coffee'
fuzzy = require 'fuzzy'
StoreUtils = require '../utils/StoreUtils.coffee'

_store = Immutable.fromJS(
  orchestrationsById: {}
)
_loadingOrchestrations = Immutable.List([])

_filter = ''

_isLoading = false

_isLoaded = false


updateOrchestration = (id, payload) ->
  _store = _store.updateIn(['orchestrationsById', id], (orchestration) ->
    orchestration.merge payload
  )

removeOrchestrationFromLoading = (id) ->
  _loadingOrchestrations = _loadingOrchestrations.remove(_loadingOrchestrations.indexOf(id))

OrchestrationStore = StoreUtils.createStore

  getAll: ->
    _store.get 'orchestrationsById'

  get: (id) ->
    _store.getIn ['orchestrationsById', parseInt(id)]

  getFiltered: ->
    _store.get('orchestrationsById').filter((orchestration) ->
      if _filter
        fuzzy.match(_filter, orchestration.get('name'))
      else
        true
    )

  getFilter: ->
    _filter

  getIsLoading: ->
    _isLoading

  getIsOrchestrationLoading: (id) ->
    _loadingOrchestrations.contains id

  getIsLoaded: ->
    _isLoaded



Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.ORCHESTRATIONS_SET_FILTER
      _filter = action.query.trim()
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_ACTIVATE
      updateOrchestration action.orchestrationId,
        active: true
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_DISABLE
      updateOrchestration action.orchestrationId,
        active: false
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATIONS_LOAD
      _isLoading = true
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATIONS_LOAD_SUCCESS
      _isLoading = false
      _isLoaded = true

      _store = _store.set 'orchestrationsById', Immutable.fromJS(action.orchestrations).toMap().mapKeys((key, orchestration) ->
        orchestration.get 'id'
      )

      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_LOAD
      _loadingOrchestrations = _loadingOrchestrations.push action.orchestrationId
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_LOAD_ERROR
      removeOrchestrationFromLoading(action.orchestrationId)
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_LOAD_SUCCESS
      removeOrchestrationFromLoading(action.orchestration.id)
      _store = _store.setIn ['orchestrationsById', action.orchestration.id], Immutable.fromJS(action.orchestration)
      OrchestrationStore.emitChange()

module.exports = OrchestrationStore