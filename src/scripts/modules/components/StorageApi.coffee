
request = require '../../utils/request'
ApplicationStore = require '../../stores/ApplicationStore'

createUrl = (path) ->
  baseUrl = ApplicationStore.getSapiUrl()
  "#{baseUrl}/v2/storage/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())


storageApi =

  getBuckets: ->
    createRequest('GET', 'buckets')
    .promise()
    .then((response) ->
      response.body
    )

  getTables: ->
    createRequest('GET', 'tables')
    .promise()
    .then((response) ->
      response.body
    )

module.exports = storageApi
