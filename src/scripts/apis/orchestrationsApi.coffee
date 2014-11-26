
Promise = require 'bluebird'
request = require 'superagent'
require 'superagent-bluebird-promise'

ApplicationStore = require '../stores/ApplicationStore.coffee'

createUrl = (path) ->
  "https://syrup.keboola.com/orchestrator/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())


orchestrationsApi =

  getOrchestrations: ->
    createRequest('GET', 'orchestrations')
    .promise()
    .then((response) ->
      response.body
    )

  getOrchestration: (id) ->
    createRequest('GET', "orchestrations/#{id}")
    .promise()
    .then((response) ->
      response.body
    )

  getOrchestrationJobs: (id) ->
    createRequest('GET', "orchestrations/#{id}/jobs")
    .promise()
    .then((response) ->
      response.body
    )

  getJob: (id) ->
    createRequest('GET', "jobs/#{id}")
    .promise()
    .then((response) ->
      response.body
    )

module.exports = orchestrationsApi