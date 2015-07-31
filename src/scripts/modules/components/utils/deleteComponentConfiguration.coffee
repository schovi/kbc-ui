componentHasApi = require './hasComponentApi'

installedComponentsApi = require '../InstalledComponentsApi'
syrupApi = require '../SyrupComponentApi'
componentsStore = require '../stores/ComponentsStore'

module.exports = (componentId, configurationId) ->
  component = componentsStore.getComponent(componentId)
  if componentHasApi(componentId) and !component.get('flags').includes 'genericUI'
    syrupApi
    .createRequest(componentId, 'DELETE', "configs/#{configurationId}")
    .promise()
    .then ->
      installedComponentsApi.deleteConfiguration componentId, configurationId
  else
    installedComponentsApi.deleteConfiguration componentId, configurationId
