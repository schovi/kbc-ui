dispatcher = require('../../Dispatcher.coffee')
JobsStore = require('./stores/JobsStore.coffee')
Promise = require('bluebird')
constants = require('./Constants.coffee')
jobsApi = require('./JobsApi.coffee')


module.exports =
  loadJobs: ->
    return Promise.resolve() if JobsStore.getIsLoaded()
    @loadJobsForce()

  loadJobsForce: ->
    actions = @
    dispatcher.handleViewAction type: constants.ActionTypes.JOBS_LOAD
    jobsApi.getJobs().then (jobs) ->
      actions.recieveAllJobs(jobs)
    .catch (err) ->
      console.log 'error', err

  recieveAllJobs:(jobs) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.JOBS_LOAD_SUCCESS
      jobs: jobs
