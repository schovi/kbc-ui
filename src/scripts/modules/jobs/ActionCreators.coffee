dispatcher = require('../../Dispatcher.coffee')
JobsStore = require('./stores/JobsStore.coffee')
Promise = require('bluebird')
constants = require('./Constants.coffee')
jobsApi = require('./JobsApi.coffee')


module.exports =
  loadJobs: ->
    return Promise.resolve() if JobsStore.getIsLoaded()
    @loadJobsForce(JobsStore.getOffset())

  loadJobsMoveOffset: ->
    @loadMoreJobs(true)

  reloadJobs: () ->
    @loadJobsForce(JobsStore.getOffset())

  loadMoreJobs: () ->
    offset = JobsStore.getNextOffset()
    @loadJobsForce(offset)

  loadJobsForce: (offset) ->
    actions = @
    limit = JobsStore.getLimit()
    query = JobsStore.getQuery()
    dispatcher.handleViewAction type: constants.ActionTypes.JOBS_LOAD
    jobsApi.getJobsParametrized(query,limit,offset).then (jobs) ->
      actions.recieveJobs(jobs, offset)

  recieveJobs:(jobs,newOffset) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_LOAD_SUCCESS
      jobs: jobs
      newOffset: newOffset

  setQuery:(query) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_SET_QUERY
      query: query
