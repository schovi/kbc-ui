installedComponentsApi = require '../InstalledComponentsApi'
syrupApi = require '../SyrupComponentApi'
constants = require '../Constants'
string = require '../../../utils/string'
ComponentsStore = require '../stores/ComponentsStore'
ApplicationStore = require '../../../stores/ApplicationStore'
Promise = require 'bluebird'

COMPONENTS_WITHOUT_API = ['tde-exporter', 'geneea-topic-detection',
'geneea-language-detection', 'geneea-lemmatization', 'geneea-sentiment-analysis', 'geneea-text-correction']

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

# Custom create method for GoodData writer
createGoodDataWriter = (configuration) ->
  writerId = string.webalize(configuration.get('name'), '_')
  params =
    writerId: writerId
    description: configuration.get 'description'
    users: ApplicationStore.getKbcVars().get('adminEmails').join ','

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

  console.log 'params', params
  syrupApi
  .createRequest('gooddata-writer', 'POST', 'writers')
  .send params
  .promise()
  .then ->
    id: writerId


module.exports = (componentId, configuration) ->
  component = ComponentsStore.getComponent componentId

  if componentId == 'gooddata-writer'
    promise = createGoodDataWriter(configuration)
  else if component.get('uri') and (component.get('id') not in COMPONENTS_WITHOUT_API)
    promise = createConfigByApi(componentId, configuration)
  else
    promise = createConfigManually(configuration)

  promise.then (response) ->
    installedComponentsApi
    .createConfiguration componentId,
      name: configuration.get 'name'
      description: configuration.get 'description'
      configurationId: response.id
