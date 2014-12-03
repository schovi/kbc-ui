

dispatcher = require '../../Dispatcher.coffee'
constants = require './Constants.coffee'
orchestrationsApi = require './OrchestrationsApi.coffee'
OrchestrationStore = require './stores/OrchestrationsStore.coffee'


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
  ###
  loadOrchestrations: ->
    # don't load if already loaded
    return if OrchestrationStore.getIsLoaded()

    @loadOrchestrationsForce()

  ###
    Request specified orchestration load from server
  ###
  loadOrchestration: (id) ->
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
    .catch((error) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATION_LOAD_ERROR
          orchestrationId: id
          status: error.status
          response: error.response
        )
      )

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
  loadJob: (jobId) ->
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
    .catch((error) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATION_JOB_LOAD_ERROR
          jobId: jobId
          status: error.status
          response: error.response
        )
      )

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
