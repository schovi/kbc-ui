
EventEmitter = require('events').EventEmitter
Dispatcher = require '../dispatcher/KbcDispatcher.coffee'
assign = require 'object-assign'
Immutable = require('immutable')
Constants = require '../constants/KbcConstants.coffee'
fuzzy = require 'fuzzy'

_jobsByOrchestrationId = Immutable.Map({})
_loadingOrchestrationJobs = Immutable.List([])
_loadingJobs = Immutable.List([])

removeFromLoadingOrchestrations = (orchestrationId) ->
  _loadingOrchestrationJobs = _loadingOrchestrationJobs.remove(_loadingOrchestrationJobs.indexOf(orchestrationId))

removeFromLoadingJobs = (jobId) ->
  _loadingJobs = _loadingJobs.remove(_loadingJobs.indexOf(jobId))

CHANGE_EVENT = 'change'

OrchestrationJobsStore = assign {}, EventEmitter.prototype,

  getOrchestrationJobs: (idOrchestration) ->
    _jobsByOrchestrationId.get(idOrchestration) || Immutable.List()

  getJob: (id) ->
    foundJob = null
    _jobsByOrchestrationId.find (jobs) ->
      foundJob = jobs.find (job) -> job.get('id') == id
    foundJob

  isJobLoading: (idJob) ->
    _loadingJobs.contains idJob

  isLoading: (idOrchestration) ->
    _loadingOrchestrationJobs.contains idOrchestration

  addChangeListener: (callback) ->
    @on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(CHANGE_EVENT, callback)

  emitChange: ->
    @emit(CHANGE_EVENT)


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when Constants.ActionTypes.ORCHESTRATION_JOBS_LOAD
      _loadingOrchestrationJobs = _loadingOrchestrationJobs.push action.orchestrationId
      OrchestrationJobsStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_JOBS_LOAD_ERROR
      removeFromLoadingOrchestrations(action.orchestrationId)
      OrchestrationJobsStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_JOBS_LOAD_SUCCESS
      removeFromLoadingOrchestrations(action.orchestrationId)
      _jobsByOrchestrationId = _jobsByOrchestrationId.set action.orchestrationId, Immutable.fromJS(action.jobs)
      OrchestrationJobsStore.emitChange()


    when Constants.ActionTypes.ORCHESTRATION_JOB_LOAD
      _loadingJobs = _loadingJobs.push action.jobId
      OrchestrationJobsStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_JOB_LOAD_SUCCESS
      removeFromLoadingJobs(action.job.id)
      data = {}
      data[action.orchestrationId] = [action.job]

      _jobsByOrchestrationId = _jobsByOrchestrationId.merge Immutable.fromJS(data)
      console.log  _jobsByOrchestrationId.toJS()


  true

module.exports = OrchestrationJobsStore