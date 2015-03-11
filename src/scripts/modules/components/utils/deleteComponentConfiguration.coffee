
installedComponentsApi = require '../InstalledComponentsApi'
syrupApi = require '../SyrupComponentApi'

module.exports = (componentId, configurationId) ->
  syrupApi
  .createRequest(componentId, 'DELETE', "configs/#{configurationId}")
  .promise()
  .then ->
    installedComponentsApi.deleteConfiguration componentId, configurationId
