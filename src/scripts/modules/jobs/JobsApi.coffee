request = require('../../utils/request.coffee')
ApplicationStore = require '../../stores/ApplicationStore.coffee'
ComponentsStore = require '../components/stores/ComponentsStore.coffee'

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
      .promise()
      .then (response) ->
        response.body

    getJobDetail: (jobId) ->
      createRequest('GET','job/' + jobId)
      .promise()
      .then (response) ->
        response.body
