
request = require '../../utils/request'

ApplicationStore = require '../../stores/ApplicationStore'
ComponentsStore = require '../components/stores/ComponentsStore'

createUrl = (path) ->
  baseUrl = ComponentsStore.getComponent('orchestrator').get('uri')
  "#{baseUrl}/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())

orchestrationsApi =

  createOrchestration: (data) ->
    createRequest('POST', 'orchestrations')
    .send(data)
    .promise()
    .then((response) ->
      response.body
    )

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

  deleteOrchestration: (id) ->
    createRequest('DELETE', "orchestrations/#{id}")
    .promise()

  runOrchestration: (id) ->
    createRequest('POST', "orchestrations/#{id}/jobs")
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

  saveOrchestrationTasks: (id, tasks) ->
    createRequest('PUT', "orchestrations/#{id}/tasks")
    .send(tasks)
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