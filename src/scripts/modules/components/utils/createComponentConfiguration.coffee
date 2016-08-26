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
    if configuration.get('tokenType') == constants.GoodDataWriterTokenTypes.CUSTOM
      params.accessToken = configuration.get 'accessToken'
    else
      params.accessToken = ApplicationStore.getKbcVars().getIn [
        'goodDataTokens'
        configuration.get('tokenType').toLowerCase()
      ]

  # create from existing
  if configuration.get('mode') == constants.GoodDataWriterModes.EXISTING
    params.pid = configuration.get 'pid'
    params.username = configuration.get 'username'
    params.password = configuration.get 'password'

  syrupApi
  .createRequest('gooddata-writer', 'POST', 'writers')
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
  else
    promise = createConfigManually(configuration)

  promise.then (response) ->
    installedComponentsApi
    .createConfiguration componentId,
      name: configuration.get 'name'
      description: configuration.get 'description'
      configurationId: response.id
