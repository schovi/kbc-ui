
request = require '../../utils/request'

ApplicationStore = require '../../stores/ApplicationStore'
ComponentsStore = require '../components/stores/ComponentsStore'

createUrl = (path) ->
  "https://connection.keboola.com/v2/storage/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())

eventsApi =

  listEvents: (params) ->
    createRequest('GET', 'events')
    .query(params)
    .timeout(4000)
    .promise()
    .then((response) ->
      response.body
    )


module.exports = eventsApi