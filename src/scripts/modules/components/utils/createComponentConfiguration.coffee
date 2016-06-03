installedComponentsApi = require '../InstalledComponentsApi'
syrupApi = require '../SyrupComponentApi'
constants = require '../Constants'
string = require('../../../utils/string').default
ComponentsStore = require '../stores/ComponentsStore'
ApplicationStore = require '../../../stores/ApplicationStore'
componentHasApi = require './hasComponentApi'
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
    id: string.webalize(configuration.get('name')) + '-' + Math.round(new Date().getTime() % 100)


# Custom create method for GoodData writer
createGoodDataWriter = (configuration) ->
  writerId = string.webalize(configuration.get('name'), '_')
  params =
    writerId: writerId
    description: configuration.get 'description'

  # create new
  if configuration.get('mode') == constants.GoodDataWriterModes.NEW
    params.authToken = configuration.get 'authToken'

  # create from existing
  if configuration.get('mode') == constants.GoodDataWriterModes.EXISTING
    params.pid = configuration.get 'pid'
    params.username = configuration.get 'username'
    params.password = configuration.get 'password'
    params.readModel = configuration.get 'readModel'

  if configuration.get('customDomain')
    params.domain = configuration.get 'domain'
    params.username = configuration.get 'username'
    params.password = configuration.get 'password'
    params.backendUrl = configuration.get 'backendUrl'
    params.ssoProvider = configuration.get 'ssoProvider'
    params.ssoKey = configuration.get 'ssoKey'

  syrupApi
  .createRequest('gooddata-writer', 'POST', 'v2')
  .send params
  .promise()
  .then ->
    id: writerId

module.exports = (componentId, configuration) ->
  component = ComponentsStore.getComponent componentId
  flags = component.get('flags')
  if componentId == 'gooddata-writer'
    promise = createGoodDataWriter(configuration)
  else if component.get('uri') and
      componentHasApi(component.get('id')) and
      !(flags.includes 'genericUI') and
      !(flags.includes 'genericDockerUI') and
      !(flags.includes 'genericTemplatesUI')
    promise = createConfigByApi(componentId, configuration)
    promise.then (response) ->
      installedComponentsApi
      .createConfiguration componentId,
        name: configuration.get 'name'
        description: configuration.get 'description'
        configurationId: response.id
  else
    installedComponentsApi
    .createConfiguration componentId,
      name: configuration.get 'name'
      description: configuration.get 'description'


