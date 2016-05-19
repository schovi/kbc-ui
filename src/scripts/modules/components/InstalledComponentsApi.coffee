request = require '../../utils/request'
ApplicationStore = require '../../stores/ApplicationStore'
TransformationBucketsStore = require '../transformations/stores/TransformationBucketsStore'
InstalledComponentsStore = require './stores/InstalledComponentsStore'

createUrl = (path) ->
  baseUrl = ApplicationStore.getSapiUrl()
  "#{baseUrl}/v2/storage/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())


installedComponentsApi =

  getComponentConfigData: (componentId, configId) ->
    url = "components/#{componentId}/configs/#{configId}"
    createRequest('GET', url)
    .promise()
    .then((response) ->
      response.body?.configuration
    )

  getComponents: ->
    createRequest('GET', 'components')
    .promise()
    .then((response) ->
      response.body
    )

  getComponentConfigurations: (componentId) ->
    createRequest('GET', "components/#{componentId}/configs")
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

  updateComponentConfigurationEncrypted: (componentUrl, configurationId, data) ->
    request('PUT', "#{componentUrl}/configs/#{configurationId}")
    .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())
    .type 'form'
    .send data
    .promise()
    .then (response) ->
      response.body

  createConfiguration: (componentId, data, changeDescription) ->
    if (changeDescription)
      data.changeDescription = changeDescription
    createRequest 'POST', "components/#{componentId}/configs"
    .type 'form'
    .send data
    .promise()
    .then (response) ->
      response.body

  deleteConfiguration: (componentId, configurationId) ->
    createRequest 'DELETE', "components/#{componentId}/configs/#{configurationId}"
    .promise()
    .then (response) ->
      response.body

  getComponentConfigVersions: (componentId, configId) ->
    url = "components/#{componentId}/configs/#{configId}/versions"
    createRequest('GET', url)
    .promise()
    .then((response) ->
      response.body
    )

  rollbackVersion: (componentId, configId, version) ->
    url = "components/#{componentId}/configs/#{configId}/versions/#{version}/rollback"
    createRequest('POST', url)
    .promise()
    .then((response) ->
      response.body
    )

  createConfigCopy: (componentId, configId, version, name) ->
    if (componentId == 'transformation')
      config = TransformationBucketsStore.get(configId)
    else
      config = InstalledComponentsStore.getConfig(componentId, configId)

    description = "Created from #{config.get('name')} version \##{version}"

    if (config.get('description'))
      description += "\n\n#{config.get('description')}"

    url = "components/#{componentId}/configs/#{configId}/versions/#{version}/create"
    data =
      name: name
      description: description
    createRequest('POST', url)
    .type 'form'
    .send data
    .promise()
    .then((response) ->
      response.body
    )

  createConfigurationRow: (componentId, configurationId, data, changeDescription) ->
    if (changeDescription)
      data.changeDescription = changeDescription
    createRequest 'POST', "components/#{componentId}/configs/#{configurationId}/rows"
    .type 'form'
    .send data
    .promise()
    .then (response) ->
      response.body

  deleteConfigurationRow: (componentId, configurationId, rowId, changeDescription) ->
    data =
      changeDescription: changeDescription
    createRequest 'DELETE', "components/#{componentId}/configs/#{configurationId}/rows/#{rowId}"
    .type 'form'
    .send data
    .promise()
    .then (response) ->
      response.body

  updateConfigurationRow: (componentId, configurationId, rowId, data) ->
    createRequest 'PUT', "components/#{componentId}/configs/#{configurationId}/rows/#{rowId}"
    .type 'form'
    .send data
    .promise()
    .then (response) ->
      response.body

module.exports = installedComponentsApi
