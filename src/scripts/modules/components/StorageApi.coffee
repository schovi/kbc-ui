request = require '../../utils/request'
parse = require '../../utils/parseCsv'
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

  getBucketCredentials: (bucketId) ->
    createRequest('GET', "buckets/#{bucketId}/credentials")
    .promise()
    .then((response) ->
      response.body
    )

  createBucketCredentials: (bucketId, name) ->
    createRequest 'POST', "buckets/#{bucketId}/credentials"
    .type 'form'
    .send {name: name}
    .promise()
    .then (response) ->
      response.body

  deleteBucketCredentials: (credentialsId) ->
    createRequest 'DELETE', "credentials/#{credentialsId}"
    .promise()
    .then((response) ->
      response.body
    )

  getTables: ->
    createRequest('GET', 'tables?include=attributes,buckets,columns')
    .promise()
    .then((response) ->
      response.body
    )

  createToken: (params) ->
    createRequest 'POST', 'tokens'
    .type 'form'
    .send params
    .promise()
    .then (response) ->
      response.body


  getTokens: ->
    createRequest 'GET', 'tokens'
    .promise()
    .then (response) ->
      response.body

  getFiles: (params) ->
    createRequest('GET', 'files')
    .query params
    .promise()
    .then((response) ->
      response.body
    )

  getRunIdStats: (runId) ->
    createRequest 'GET', 'stats'
    .query runId: runId
    .promise()
    .then (response) ->
      response.body


  getKeenCredentials: ->
    createRequest 'GET', 'tokens/keen'
    .promise()
    .then (response) ->
      response.body

  ###
    Returns parsed CSV info plain arrays
    [
      [] - row 1
      [] - row 2
    ]
  ###
  exportTable: (tableId, params) ->
    createRequest('GET', "tables/#{tableId}/export")
    .query params
    .promise()
    .then (response) ->
      parse response.text

  prepareFileUpload: (params) ->
    createRequest('POST', "files/prepare")
    .type 'form'
    .send params
    .promise()
    .then (response) ->
      response.body


  createBucket: (params) ->
    createRequest('POST', "buckets")
    .type 'form'
    .send params
    .promise()
    .then (response) ->
      response.body

  createTable: (bucketId, params) ->
    createRequest('POST', "buckets/#{bucketId}/tables-async")
    .type 'form'
    .send params
    .promise()
    .then (response) ->
      response.body

  loadTable: (tableId, params) ->
    createRequest('POST', "tables/#{tableId}/import-async")
    .type 'form'
    .send params
    .promise()
    .then (response) ->
      response.body

module.exports = storageApi
