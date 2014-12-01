
Dispatcher = require '../dispatcher/KbcDispatcher.coffee'
Immutable = require('immutable')
Constants = require '../constants/KbcConstants.coffee'
fuzzy = require 'fuzzy'
StoreUtils = require '../utils/StoreUtils.coffee'

_jobsByOrchestrationId = Immutable.Map({})
_loadingOrchestrationJobs = Immutable.List([])
_loadingJobs = Immutable.List([])

removeFromLoadingOrchestrations = (orchestrationId) ->
  _loadingOrchestrationJobs = _loadingOrchestrationJobs.remove(_loadingOrchestrationJobs.indexOf(orchestrationId))

removeFromLoadingJobs = (jobId) ->
  _loadingJobs = _loadingJobs.remove(_loadingJobs.indexOf(jobId))

OrchestrationJobsStore = StoreUtils.createStore

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


module.exports = OrchestrationJobsStore