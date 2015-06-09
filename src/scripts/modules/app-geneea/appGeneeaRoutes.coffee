genericIndex = require '../app-geneea/react/pages/index/Index'
genericHeaderButtons = require './react/components/detailHeaderButtons'

installedComponentsActions = require '../components/InstalledComponentsActionCreators'
IntalledComponentsStore = require '../components/stores/InstalledComponentsStore'
JobsActionCreators = require '../jobs/ActionCreators'

createRoute = (componentId, outtableSuffix) ->
  name: componentId
  path: "#{componentId}/:config"
  isComponent: true
  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData componentId, params.config
  ]
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    IntalledComponentsStore.getConfig(componentId, configId).get 'name'
  poll:
    interval: 5
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs(componentId, params.config)
  defaultRouteHandler: genericIndex(componentId, outtableSuffix)
  headerButtonsHandler: genericHeaderButtons(componentId)



module.exports =
  topicDetection: createRoute 'geneea-topic-detection', 'topic'
  sentimentAnalysis: createRoute 'geneea-sentiment-analysis', 'sentiment'
  lemmatization: createRoute 'geneea-lemmatization', 'lemma'
  correction: createRoute 'geneea-text-correction', 'correction'
  languageDetection: createRoute 'geneea-language-detection', 'lang'
