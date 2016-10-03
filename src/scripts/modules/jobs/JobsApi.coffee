request = require('../../utils/request')
ApplicationStore = require '../../stores/ApplicationStore'
ComponentsStore = require '../components/stores/ComponentsStore'

createUrl = (path) ->
  baseUrl = ComponentsStore.getComponent('queue').get('uri')
  "#{baseUrl}/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())


module.exports =
  jobsApi =
    getJobs: ->
      createRequest('GET', 'jobs')
      .promise()
      .then (response) ->
        response.body

    getJobsParametrized: (query, limit, offset) ->
      createRequest('GET','jobs')
      .query({'q': query})
      .query({'limit': limit})
      .query({'offset': offset})
      .query({'include': 'metrics'})
      .promise()
      .then (response) ->
        response.body

    getJobDetail: (jobId) ->
      createRequest('GET','jobs/' + jobId + '?include=metrics')
      .promise()
      .then (response) ->
        response.body

    terminateJob: (jobId) ->
      createRequest('POST', "jobs/#{jobId}/kill")
      .promise()
      .then (response) ->
        response.body

    saveJobErrorNote: (jobId, errorNote) ->
      createRequest('PUT', "jobs/#{jobId}/error-note")
      .send(
        errorNote: errorNote
      )
      .promise()
      .then (response) ->
        response.body
