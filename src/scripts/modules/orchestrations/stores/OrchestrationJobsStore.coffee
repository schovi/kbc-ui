
Dispatcher = require '../../../Dispatcher.coffee'
Immutable = require('immutable')
{Map, List} = Immutable
Constants = require '../Constants.coffee'
fuzzy = require 'fuzzy'
StoreUtils = require '../../../utils/StoreUtils.coffee'

_store = Map(
  jobsByOrchestrationId: Map()
  loadingOrchestrationJobs: List()
  loadingJobs: List()
)

addToLoadingOrchestrations = (store, orchestrationId) ->
  store.update 'loadingOrchestrationJobs', (loadingOrchestrationJobs) ->
    loadingOrchestrationJobs.push orchestrationId

removeFromLoadingOrchestrations = (store, orchestrationId) ->
  store.update 'loadingOrchestrationJobs', (loadingOrchestrationJobs) ->
    loadingOrchestrationJobs.remove(loadingOrchestrationJobs.indexOf(orchestrationId))

addToLoadingJobs = (store, jobId) ->
  store.update 'loadingJobs', (loadingOrchestrationJobs) ->
    loadingOrchestrationJobs.push jobId

removeFromLoadingJobs = (store, jobId) ->
  store.update 'loadingJobs', (loadingJobs) ->
    loadingJobs.remove(loadingJobs.indexOf(jobId))


OrchestrationJobsStore = StoreUtils.createStore

  ###
    Returns all jobs for orchestration sorted by id desc
  ###
  getOrchestrationJobs: (idOrchestration) ->
    _store
      .getIn(['jobsByOrchestrationId', parseInt(idOrchestration)], List())
      .sortBy((job) -> -1 * job.get 'id')

  ###
    Check if store contains job for specifed orchestration
  ###
  hasOrchestrationJobs: (idOrchestration) ->
    _store.get('jobsByOrchestrationId').has parseInt(idOrchestration)

  ###
    Returns one job by it's id
  ###
  getJob: (id) ->
    foundJob = null
    _store.get('jobsByOrchestrationId').find (jobs) ->
      foundJob = jobs.find (job) -> job.get('id') == parseInt(id)
    foundJob

  ###
    Test if job is currently being loaded
  ###
  isJobLoading: (idJob) ->
    _store.get('loadingJobs').contains idJob

  ###
    Test if specified orchestration jobs are currently being loaded
  ###
  isLoading: (idOrchestration) ->
    _store.get('loadingOrchestrationJobs').contains parseInt(idOrchestration)


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when Constants.ActionTypes.ORCHESTRATION_JOBS_LOAD
      _store = addToLoadingOrchestrations(_store, parseInt(action.orchestrationId))
      OrchestrationJobsStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_JOBS_LOAD_ERROR
      _store = removeFromLoadingOrchestrations(_store, parseInt(action.orchestrationId))
      OrchestrationJobsStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_JOBS_LOAD_SUCCESS
      _store = _store.withMutations((store) ->
        removeFromLoadingOrchestrations(store, parseInt(action.orchestrationId))
        .update('jobsByOrchestrationId', (jobsByOrchestrationId) ->
            jobsByOrchestrationId.set parseInt(action.orchestrationId), Immutable.fromJS(action.jobs)
        )
      )
      OrchestrationJobsStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_JOB_LOAD
      _store = addToLoadingJobs(_store, action.jobId)
      OrchestrationJobsStore.emitChange()

    when Constants.ActionTypes.ORCHESTRATION_JOB_LOAD_SUCCESS
      data = {}
      data[action.orchestrationId] = [action.job]

      _store = _store.withMutations((store) ->
        removeFromLoadingJobs(store, action.job.id)
        .update('jobsByOrchestrationId', (jobsByOrchestrationId) ->
            jobsByOrchestrationId.merge Immutable.fromJS(data)
        )
      )
      OrchestrationJobsStore.emitChange()


module.exports = OrchestrationJobsStore