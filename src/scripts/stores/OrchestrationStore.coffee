
EventEmitter = require('events').EventEmitter
Dispatcher = require '../dispatcher/KbcDispatcher.coffee'
assign = require 'object-assign'
Immutable = require('immutable')
Constants = require '../constants/KbcConstants.coffee'
fuzzy = require 'fuzzy'

_orchestrationsById = Immutable.Map({})
_loadingOrchestrations = Immutable.List([])

_filter = ''

_isLoading = false

_isLoaded = false

CHANGE_EVENT = 'change'


updateOrchestration = (id, payload) ->
  _orchestrationsById = _orchestrationsById.update(id, (orchestration) ->
    orchestration.merge payload
  )

removeOrchestrationFromLoading = (id) ->
  _loadingOrchestrations = _loadingOrchestrations.remove(_loadingOrchestrations.indexOf(id))

OrchestrationStore = assign {}, EventEmitter.prototype,

  getAll: ->
    _orchestrationsById

  get: (id) ->
    idInt = parseInt id
    _orchestrationsById.find((orchestration) ->
      orchestration.get('id') == idInt
    )

  getFiltered: ->
    _orchestrationsById.filter((orchestration) ->
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
    console.log 'is loading', id, _loadingOrchestrations.toJS()
    _loadingOrchestrations.contains id

  getIsLoaded: ->
    _isLoaded

  addChangeListener: (callback) ->
    @on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(CHANGE_EVENT, callback)

  emitChange: ->
    @emit(CHANGE_EVENT)


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
      _orchestrationsById = Immutable.fromJS(action.orchestrations).toMap().mapKeys((key, orchestration) ->
        orchestration.get 'id'
      )
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_LOAD
      console.log 'start load', action.orchestrationId
      _loadingOrchestrations = _loadingOrchestrations.push action.orchestrationId
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_LOAD_ERROR
      console.log 'revmoe', action.orchestrationId
      removeOrchestrationFromLoading(action.orchestrationId)
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_LOAD_SUCCESS
      console.log 'success load', action.orchestration.id
      removeOrchestrationFromLoading(action.orchestration.id)
      console.log 'loading', _loadingOrchestrations.toJS()
      _orchestrationsById = _orchestrationsById.set action.orchestration.id, Immutable.fromJS(action.orchestration)
      OrchestrationStore.emitChange()

  true

module.exports = OrchestrationStore