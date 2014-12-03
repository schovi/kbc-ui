

dispatcher = require '../../Dispatcher.coffee'
constants = require './Constants.coffee'
orchestrationsApi = require './OrchestrationsApi.coffee'
OrchestrationStore = require './stores/OrchestrationsStore.coffee'
OrchestrationJobsStore = require './stores/OrchestrationJobsStore.coffee'
Promise = require 'bluebird'


module.exports =

  ###
    Request orchestrations reload from server
  ###
  loadOrchestrationsForce: ->
    # trigger load initialized
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATIONS_LOAD
    )

    # init load
    orchestrationsApi
    .getOrchestrations()
    .then((orchestrations) ->
        # load success
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATIONS_LOAD_SUCCESS
          orchestrations: orchestrations
        )
      )
    .catch (err) ->
        console.log 'error', err

  ###
    Request orchestrations load only if not alread loaded
    @return Promise
  ###
  loadOrchestrations: ->
    # don't load if already loaded
    return Promise.resolve() if OrchestrationStore.getIsLoaded()

    @loadOrchestrationsForce()

  ###
    Request specified orchestration load from server
    @return Promise
  ###
  loadOrchestrationForce: (id) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATION_LOAD
      orchestrationId: id
    )

    orchestrationsApi
    .getOrchestration(id)
    .then((orchestration) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATION_LOAD_SUCCESS
          orchestration: orchestration
        )
        return
      )

  loadOrchestration: (id) ->
    return Promise.resolve() if OrchestrationStore.get(id)
    @loadOrchestrationForce(id)

  ###
    Load specifed orchestration jobs from server
  ###
  loadOrchestrationJobs: (orchestrationId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATION_JOBS_LOAD
      orchestrationId: orchestrationId
    )

    orchestrationsApi
    .getOrchestrationJobs(orchestrationId)
    .then((jobs) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATION_JOBS_LOAD_SUCCESS
          orchestrationId: orchestrationId
          jobs: jobs
        )
      )
    .catch((error) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATION_JOBS_LOAD_ERROR
          orchestrationId: orchestrationId
          status: error.status
          response: error.response
        )
      )

  ###
    Fetch single job from server
  ###
  loadJobForce: (jobId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATION_JOB_LOAD
      jobId: jobId
    )

    orchestrationsApi
    .getJob(jobId)
    .then((job) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATION_JOB_LOAD_SUCCESS
          orchestrationId: job.orchestrationId
          job: job
        )
      )

  ###
    Ensure that job is loaded, cached version is accpeted
  ###
  loadJob: (jobId) ->
    return Promise.resolve() if OrchestrationJobsStore.getJob(jobId)
    @loadJobForce jobId

  ###
    Filter orchestrations
  ###
  setOrchestrationsFilter: (query) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATIONS_SET_FILTER
      query: query
    )

  activateOrchestration: (id) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATION_ACTIVATE
      orchestrationId: id
    )

    orchestrationsApi.updateOrchestration(id,
      active: true
    )

  disableOrchestration: (id) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATION_DISABLE
      orchestrationId: id
    )

    orchestrationsApi.updateOrchestration(id,
      active: false
    )
