
request = require '../../utils/request'
ApplicationStore = require '../../stores/ApplicationStore'

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

  updateComponentConfiguration: (componentId, configurationId, data) ->
    createRequest 'PUT', "components/#{componentId}/configs/#{configurationId}"
    .type 'form'
    .send data
    .promise()
    .then (response) ->
      response.body

module.exports = installedComponentsApi