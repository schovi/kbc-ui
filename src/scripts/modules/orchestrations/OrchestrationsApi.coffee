
request = require '../../utils/request.coffee'

ApplicationStore = require '../../stores/ApplicationStore.coffee'
ComponentsStore = require '../components/stores/ComponentsStore.coffee'

createUrl = (path) ->
  baseUrl = ComponentsStore.getComponent('orchestrator').get('uri')
  "#{baseUrl}/#{path}"

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

  updateOrchestration: (id, data) ->
    createRequest('PUT', "orchestrations/#{id}")
    .send(data)
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