componentHasApi = require './hasComponentApi'

installedComponentsApi = require '../InstalledComponentsApi'
syrupApi = require '../SyrupComponentApi'
componentsStore = require '../stores/ComponentsStore'

module.exports = (componentId, configurationId) ->
  component = componentsStore.getComponent(componentId)
  if componentHasApi(componentId) and
      !component.get('flags').includes('genericUI') and
      !component.get('flags').includes('genericDockerUI')
    syrupApi
    .createRequest(componentId, 'DELETE', "configs/#{configurationId}")
    .promise()
    .then ->
      installedComponentsApi.deleteConfiguration componentId, configurationId
  else
    installedComponentsApi.deleteConfiguration componentId, configurationId
