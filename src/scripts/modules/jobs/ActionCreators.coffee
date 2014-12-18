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

  recieveJobs:(jobs, newOffset, resetJobs) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_LOAD_SUCCESS
      jobs: jobs
      newOffset: newOffset
      resetJobs: resetJobs

  filterJobs:(query) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_SET_QUERY
      query: query
    @loadJobsForce(0, true, false)
