
installedComponentsApi = require './InstalledComponentsApi'
syrupApi = require './SyrupComponentApi'
string = require '../../utils/string'
ComponentsStore = require './stores/ComponentsStore'
Promise = require 'bluebird'

createConfigByApi = (componentId, configuration) ->
  syrupApi
  .createRequest(componentId, 'POST', "configs")
  .send configuration.set('name', string.webalize(configuration.get('name'))).toJS()
  .promise()
  .then (response) ->
    response.body

createConfigManually = (configuration) ->
  Promise.resolve
    data:
      id: string.webalize(configuration.get('name')) + '-' + Math.round(new Date().getTime() / 1000)

module.exports =

  createComponentConfiguration: (componentId, configuration) ->
    component = ComponentsStore.getComponent componentId

    if component.get 'uri'
      promise = createConfigByApi(componentId, configuration)
    else
      promise = createConfigByApi(configuration)

    promise.then (response) ->
      installedComponentsApi
      .createConfiguration componentId,
        name: configuration.get 'name'
        description: configuration.get 'description'
        configurationId: response.id

