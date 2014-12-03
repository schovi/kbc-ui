
request = require '../../utils/request.coffee'
ApplicationStore = require '../../stores/ApplicationStore.coffee'

createUrl = (path) ->
  baseUrl = ApplicationStore.getSapiUrl()
  "#{baseUrl}/v2/storage/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())


installedComponentsApi =

  getComponents: ->
    createRequest('GET', 'components')
    .promise()
    .then((response) ->
      response.body
    )


module.exports = installedComponentsApi