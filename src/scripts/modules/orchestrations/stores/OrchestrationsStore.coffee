
Dispatcher = require '../../../Dispatcher'
Immutable = require('immutable')
Map = Immutable.Map
List = Immutable.List
Constants = require '../Constants'
fuzzy = require 'fuzzy'
StoreUtils = require '../../../utils/StoreUtils'

_store = Map(
  orchestrationsById: Map()
  orchestrationsPendingActions: Map() # by orchestration id
  tasksToRun: Map() # [orchestrationId] - tasks
  editing: Map() # [orchestrationId][tasks] - edit value
  saving: Map() # [orchestrationId][tasks] - bool value
  orchestrationTasksById: Map()
  filter: ''
  isLoading: false
  isLoaded: false
  loadingOrchestrations: List()
)

updateOrchestration = (store, id, payload) ->
  store.updateIn(['orchestrationsById', id], (orchestration) ->
    orchestration.merge payload
  )

removeOrchestrationFromLoading = (store, id) ->
  store.update 'loadingOrchestrations', (loadingOrchestrations) ->
    loadingOrchestrations.remove(store.get('loadingOrchestrations').indexOf(id))

setLastExecutedJob = (store, orchestrationId, job) ->
  orchestration = store.getIn ['orchestrationsById', orchestrationId]
  return store if !orchestration || !orchestration.get('lastExecutedJob')
  return store if orchestration.getIn(['lastExecutedJob', 'id']) > job.get('id')

  # set only if job is newer or same
  store.setIn ['orchestrationsById', orchestrationId, 'lastExecutedJob'], job


OrchestrationStore = StoreUtils.createStore

  ###
    Returns all orchestrations sorted by last execution date desc
  ###
  getAll: ->
    _store
      .get('orchestrationsById')
      .sortBy((orchestration) -> orchestration.get('name'))
      .sortBy((orchestration) ->
        date = orchestration.getIn ['lastExecutedJob', 'startTime']
        if date then -1 * (new Date(date).getTime()) else null
      )

  getPendingActions: ->
    _store.get 'orchestrationsPendingActions'

  getPendingActionsForOrchestration: (id) ->
    @getPendingActions().get(id, Map())

  ###
    Returns orchestration specified by id
  ###
  get: (id) ->
    _store.getIn ['orchestrationsById', id]

  has: (id) ->
    _store.get('orchestrationsById').has id

  getOrchestrationTasks: (orchestrationId) ->
    _store.getIn ['orchestrationTasksById', orchestrationId]

  hasOrchestrationTasks: (orchestrationId) ->
    _store.get('orchestrationTasksById').has orchestrationId

  isEditing: (orchestrationId, field) ->
    _store.hasIn ['editing', orchestrationId, field]

  isSaving: (orchestrationId, field) ->
    _store.hasIn ['saving', orchestrationId, field]

  getEditingValue: (orchestrationId, field) ->
    _store.getIn ['editing', orchestrationId, field]

  getTasksToRun: (orchestrationId) ->
    _store.getIn ['tasksToRun', orchestrationId]

  ###
    Returns all orchestrations filtered by current filter value
  ###
  getFiltered: ->
    filter = @getFilter()
    @getAll().filter((orchestration) ->
      if filter
        fuzzy.match(filter, orchestration.get('name'))
      else
        true
    )

  getFilter: ->
    _store.get 'filter'

  getIsLoading: ->
    _store.get 'isLoading'

  getIsOrchestrationLoading: (id) ->
    _store.get('loadingOrchestrations').contains id

  getIsLoaded: ->
    _store.get 'isLoaded'


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.ORCHESTRATIONS_SET_FILTER
      _store = _store.set 'filter', action.query.trim()
      OrchestrationStore.emitChange()


    when Constants.ActionTypes.ORCHESTRATION_ACTIVE_CHANGE_START
      _store = _store.setIn ['orchestrationsPendingActions', action.orchestrationId, 'active'], true
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_ACTIVE_CHANGE_ERROR
      _store = _store.deleteIn ['orchestrationsPendingActions', action.orchestrationId, 'active']
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_ACTIVE_CHANGE_SUCCESS
      _store = _store.withMutations (store) ->
        store = store.deleteIn ['orchestrationsPendingActions', action.orchestrationId, 'active']
        updateOrchestration store, action.orchestrationId,
          active: action.active
      OrchestrationStore.emitChange()


    when Constants.ActionTypes.ORCHESTRATIONS_LOAD
      _store = _store.set 'isLoading', true
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATIONS_LOAD_ERROR
      _store = _store.set 'isLoading', false
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATIONS_LOAD_SUCCESS
      _store = _store.withMutations((store) ->
        store
          .set('isLoading', false)
          .set('isLoaded', true)
          .set('orchestrationsById', Immutable.fromJS(action.orchestrations).toMap().mapKeys((key, orchestration) ->
            orchestration.get 'id'
          ))
      )
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_LOAD
      _store = _store.update 'loadingOrchestrations', (loadingOrchestrations) ->
        loadingOrchestrations.push action.orchestrationId
      OrchestrationStore.emitChange()



    when Constants.ActionTypes.ORCHESTRATION_DELETE_START
      _store = _store.setIn ['orchestrationsPendingActions', action.orchestrationId, 'delete'], true
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_DELETE_ERROR
      _store = _store.deleteIn ['orchestrationsPendingActions', action.orchestrationId, 'delete']
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_DELETE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .removeIn ['orchestrationsById', action.orchestrationId]
        .removeIn ['orchestrationsPendingActions', action.orchestrationId, 'delete']

      OrchestrationStore.emitChange()



    when Constants.ActionTypes.ORCHESTRATION_LOAD_ERROR
      _store = removeOrchestrationFromLoading(_store, action.orchestrationId)
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_LOAD_SUCCESS
      _store = _store.withMutations((store) ->
        removeOrchestrationFromLoading(store, action.orchestration.id)
        .setIn ['orchestrationsById', action.orchestration.id], Immutable.fromJS(action.orchestration)
        .setIn ['orchestrationTasksById', action.orchestration.id], Immutable.fromJS(action.orchestration.tasks)
      )
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_CREATE_SUCCESS
      _store = _store.setIn ['orchestrationsById', action.orchestration.id], Immutable.fromJS(action.orchestration)
      OrchestrationStore.emitChange()


    when Constants.ActionTypes.ORCHESTRATION_JOB_LOAD_SUCCESS
      # try to update orchestration latest job
      _store = setLastExecutedJob(_store, action.job.orchestrationId, Immutable.fromJS(action.job))
      OrchestrationStore.emitChange()


    when Constants.ActionTypes.ORCHESTRATION_JOBS_LOAD_SUCCESS
      # try to update orchestration latest job

      latestJob = Immutable.fromJS(action.jobs).last()
      if latestJob
        _store = setLastExecutedJob(_store, parseInt(action.orchestrationId), latestJob)
        OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_FIELD_EDIT_START
      console.log 'start edit'
      _store = _store.setIn ['editing', action.orchestrationId, action.field],
        OrchestrationStore.get(action.orchestrationId).get action.field
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_FIELD_EDIT_CANCEL
      _store = _store.deleteIn ['editing', action.orchestrationId, action.field]
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_FIELD_EDIT_UPDATE
      _store = _store.setIn ['editing', action.orchestrationId, action.field], action.value
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_FIELD_SAVE_START
      _store = _store.setIn ['saving', action.orchestrationId, action.field], true
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_FIELD_SAVE_ERROR
      _store = _store.deleteIn ['saving', action.orchestrationId, action.field]
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_FIELD_SAVE_SUCCESS
      _store = _store.withMutations (store) ->
        if action.orchestration
          store = store
          .setIn ['orchestrationsById', action.orchestrationId], Immutable.fromJS(action.orchestration)
        else if action[action.field]
          store = store
          .setIn ['orchestrationsById', action.orchestrationId, action.field],
            Immutable.fromJS(action[action.field])
        store
        .deleteIn ['saving', action.orchestrationId, action.field]
        .deleteIn ['editing', action.orchestrationId, action.field]
      OrchestrationStore.emitChange()


    when Constants.ActionTypes.ORCHESTRATION_RUN_TASK_EDIT_START
      _store = _store.setIn ['tasksToRun', action.orchestrationId],
        OrchestrationStore.getOrchestrationTasks(action.orchestrationId)
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_RUN_TASK_EDIT_CANCEL
      _store = _store.deleteIn ['tasksToRun', action.orchestrationId]
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_RUN_TASK_EDIT_SUCCESS
      _store = _store.deleteIn ['tasksToRun', action.orchestrationId]
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_RUN_TASK_EDIT_UPDATE
      _store = _store.setIn ['tasksToRun', action.orchestrationId], action.tasks
      OrchestrationStore.emitChange()


    when Constants.ActionTypes.ORCHESTRATION_TASKS_EDIT_START
      _store = _store.setIn ['editing', action.orchestrationId, 'tasks'],
        OrchestrationStore.getOrchestrationTasks(action.orchestrationId)
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_TASKS_EDIT_CANCEL
      _store = _store.deleteIn ['editing', action.orchestrationId, 'tasks']
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_TASKS_EDIT_UPDATE
      _store = _store.setIn ['editing', action.orchestrationId, 'tasks'], action.tasks
      OrchestrationStore.emitChange()


    when Constants.ActionTypes.ORCHESTRATION_TASKS_SAVE_START
      _store = _store.setIn ['saving', action.orchestrationId, 'tasks'], true
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_TASKS_SAVE_ERROR
      _store = _store.deleteIn ['saving', action.orchestrationId, 'tasks'],
      OrchestrationStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_TASKS_SAVE_SUCCESS
      _store = _store.withMutations((store) ->
        store
        .setIn ['orchestrationTasksById', action.orchestrationId], Immutable.fromJS(action.tasks)
        .deleteIn ['saving', action.orchestrationId, 'tasks']
        .deleteIn ['editing', action.orchestrationId, 'tasks']
      )
      OrchestrationStore.emitChange()

module.exports = OrchestrationStore
