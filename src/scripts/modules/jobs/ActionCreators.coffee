dispatcher = require('../../Dispatcher.coffee')
JobsStore = require('./stores/JobsStore.coffee')
Promise = require('bluebird')
constants = require('./Constants.coffee')
jobsApi = require('./JobsApi.coffee')


module.exports =
  loadJobs: ->
    return Promise.resolve() if JobsStore.getIsLoaded()
    @loadMoreJobs()

  loadMoreJobs: () ->
    actions = @
    limit = JobsStore.getLimit()
    offset = JobsStore.getOffset() + 1
    query = JobsStore.getQuery()
    dispatcher.handleViewAction type: constants.ActionTypes.JOBS_LOAD
    jobsApi.getJobsParametrized(query,limit,offset).then (jobs) ->
      actions.recieveMoreJobs(jobs)

  recieveMoreJobs:(jobs) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_LOAD_SUCCESS
      jobs: jobs

  setQuery:(query) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_SET_QUERY
      query: query
