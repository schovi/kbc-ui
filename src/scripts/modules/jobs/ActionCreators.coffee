dispatcher = require('../../Dispatcher')
JobsStore = require('./stores/JobsStore')
Promise = require('bluebird')
constants = require('./Constants')
jobsApi = require('./JobsApi')


module.exports =
  loadJobs: ->
    return Promise.resolve() if JobsStore.getIsLoaded()
    @loadJobsForce(JobsStore.getOffset(), false, true)

  reloadJobs: ->
    @loadJobsForce(0, false, true)

  loadMoreJobs: ->
    offset = JobsStore.getNextOffset()
    @loadJobsForce(offset, false, false)

  loadJobsForce: (offset, resetJobs, preserveCurrentOffset) ->
    actions = @
    limit = JobsStore.getLimit()
    query = JobsStore.getQuery()
    dispatcher.handleViewAction type: constants.ActionTypes.JOBS_LOAD
    jobsApi.getJobsParametrized(query, limit, offset).then (jobs) ->
      if preserveCurrentOffset
        offset = JobsStore.getOffset()
      actions.recieveJobs(jobs, offset, resetJobs)

  filterJobs: (query) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_SET_QUERY
      query: query
    @loadJobsForce(0, true, false)

  loadJobDetail: (jobId) ->
    return Promise.resolve() if JobsStore.has(jobId)
    @loadJobDetailForce jobId

  loadJobDetailForce: (jobId) ->
    actions = @
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOB_LOAD
      jobId: jobId
    jobsApi.getJobDetail(jobId).then (jobDetail) ->
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

  loadComponentConfigurationLatestJobs: (componentId, configurationId) ->

    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_LATEST_LOAD_START
      componentId: componentId
      configurationId: configurationId

    query = "component:#{componentId} AND params.config:#{configurationId}"
    jobsApi
    .getJobsParametrized(query, 10, 0)
    .then (jobs) ->
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
