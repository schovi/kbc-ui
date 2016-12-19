dispatcher = require('../../Dispatcher')
moment = require('moment')
JobsStore = require('./stores/JobsStore')
Promise = require('bluebird')
constants = require('./Constants')
jobsApi = require('./JobsApi')
RoutesStore = require '../../stores/RoutesStore'
storageActions = require '../components/StorageActionCreators'

module.exports =

  reloadSapiTablesTrigger: (jobs) ->
    tresholdTrigger = 20 #seconds of end time from now to reload all tables
    for job in jobs
      if job.endTime
        endTime = moment(job.endTime)
        now = moment()
        diff = moment.duration(now.diff(endTime))
        if (diff < moment.duration(tresholdTrigger, 'seconds'))
          return storageActions.loadTablesForce(true) #ignore force if already isLoading

  loadJobs: ->
    return Promise.resolve() if JobsStore.getIsLoaded()
    @loadJobsForce(JobsStore.getOffset(), false, true)

  reloadJobs: ->
    if JobsStore.loadJobsErrorCount() < 10
      @loadJobsForce(0, false, true)

  loadMoreJobs: ->
    offset = JobsStore.getNextOffset()
    @loadJobsForce(offset, false, false)

  loadJobsForce: (offset, resetJobs, preserveCurrentOffset) ->
    actions = @
    limit = JobsStore.getLimit()
    query = JobsStore.getQuery()
    dispatcher.handleViewAction type: constants.ActionTypes.JOBS_LOAD
    jobsApi
    .getJobsParametrized(query, limit, offset)
    .then (jobs) =>
      @reloadSapiTablesTrigger(jobs)
      if preserveCurrentOffset
        offset = JobsStore.getOffset()
      actions.recieveJobs(jobs, offset, resetJobs)
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.JOBS_LOAD_ERROR
        exception: e
      throw e

  filterJobs: (query) ->
    RoutesStore.getRouter().transitionTo 'jobs', null,
      q: query

  setQuery: (query) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_SET_QUERY
      query: query

  loadJobDetail: (jobId) ->
    return Promise.resolve() if JobsStore.has(jobId)
    @loadJobDetailForce jobId

  loadJobDetailForce: (jobId) ->
    actions = @
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOB_LOAD
      jobId: jobId
    jobsApi.getJobDetail(jobId).then (jobDetail) =>
      @reloadSapiTablesTrigger([jobDetail])
      actions.recieveJobDetail(jobDetail)

  recieveJobs: (jobs, newOffset, resetJobs) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_LOAD_SUCCESS
      jobs: jobs
      newOffset: newOffset
      resetJobs: resetJobs

  recieveJobDetail: (jobDetail) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOB_LOAD_SUCCESS
      job: jobDetail

  terminateJob: (jobId) ->
    actions = @
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOB_TERMINATE_START
      jobId: jobId

    jobsApi
    .terminateJob jobId
    .then (response) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.JOB_TERMINATE_SUCCESS
        jobId: jobId
      actions.loadJobDetailForce jobId
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.JOB_TERMINATE_ERROR
        jobId: jobId
      throw e

  loadComponentConfigurationLatestJobs: (componentId, configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_LATEST_LOAD_START
      componentId: componentId
      configurationId: configurationId

    query = "(component:#{componentId} OR params.component:#{componentId}) AND params.config:#{configurationId}"
    jobsApi
    .getJobsParametrized(query, 10, 0)
    .then (jobs) =>
      @reloadSapiTablesTrigger(jobs)

      dispatcher.handleViewAction
        type: constants.ActionTypes.JOBS_LATEST_LOAD_SUCCESS
        componentId: componentId
        configurationId: configurationId
        jobs: jobs
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.JOBS_LATEST_LOAD_ERROR
        componentId: componentId
        configurationId: configurationId
        error: e
      throw e


  jobErrorNoteUpdated: (jobId, errorNote) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOB_ERROR_NOTE_UPDATED
      jobId: jobId
      errorNote: errorNote
