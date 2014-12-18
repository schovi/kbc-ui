dispatcher = require('../../Dispatcher.coffee')
JobsStore = require('./stores/JobsStore.coffee')
Promise = require('bluebird')
constants = require('./Constants.coffee')
jobsApi = require('./JobsApi.coffee')


module.exports =
  loadJobs: ->
    return Promise.resolve() if JobsStore.getIsLoaded()
    @loadJobsForce(JobsStore.getOffset(),false, true)

  reloadJobs: () ->
    @loadJobsForce(0, false, true)

  loadMoreJobs: () ->
    offset = JobsStore.getNextOffset()
    @loadJobsForce(offset, false, false)

  loadJobsForce: (offset, resetJobs, preserveCurrentOffset) ->
    actions = @
    limit = JobsStore.getLimit()
    query = JobsStore.getQuery()
    dispatcher.handleViewAction type: constants.ActionTypes.JOBS_LOAD
    jobsApi.getJobsParametrized(query,limit,offset).then (jobs) ->
      if preserveCurrentOffset
        offset = JobsStore.getOffset()
      actions.recieveJobs(jobs, offset, resetJobs)

  filterJobs:(query) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_SET_QUERY
      query: query
    @loadJobsForce(0, true, false)


  loadJobDetail: (jobId) ->
    actions = @
    dispatcher.handleViewAction type:constants.ActionTypes.JOB_LOAD
    jobsApi.getJobDetail(jobId).then (jobDetail) ->
      actions.recieveJobDetail(jobDetail)

  recieveJobs:(jobs, newOffset, resetJobs) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_LOAD_SUCCESS
      jobs: jobs
      newOffset: newOffset
      resetJobs: resetJobs

  recieveJobDetail: (jobDetail) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOB_LOAD_SUCCESS
      job : jobDetail
