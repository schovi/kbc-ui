request = require('../../utils/request')
ApplicationStore = require '../../stores/ApplicationStore'
ComponentsStore = require '../components/stores/ComponentsStore'

createUrl = (path) ->
  baseUrl = ComponentsStore.getComponent('queue').get('uri')
  "#{baseUrl}/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())

metricsApi =
  getProjectMetrics: (dateFrom, dateTo, period) ->
    createRequest('GET', 'metrics')
    .query({'dateFrom': dateFrom})
    .query({'dateTo': dateTo})
    .query({'period': period})
    .promise()
    .then (response) ->
      response.body

module.exports = metricsApi
