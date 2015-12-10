genericIndex = require '../app-geneea/react/pages/index/Index'
genericHeaderButtons = require './react/components/detailHeaderButtons'

installedComponentsActions = require '../components/InstalledComponentsActionCreators'
IntalledComponentsStore = require '../components/stores/InstalledComponentsStore'
JobsActionCreators = require '../jobs/ActionCreators'

createComponentRoute = require('../components/createComponentRoute').default

createRoute = (componentId) ->
  createComponentRoute componentId, [
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
    defaultRouteHandler: genericIndex(componentId)
    headerButtonsHandler: genericHeaderButtons(componentId)
  ]

module.exports =
  topicDetection: createRoute 'geneea-topic-detection'
  sentimentAnalysis: createRoute 'geneea-sentiment-analysis'
  lemmatization: createRoute 'geneea-lemmatization'
  correction: createRoute 'geneea-text-correction'
  languageDetection: createRoute 'geneea-language-detection'
  entityRecognition: createRoute 'geneea-entity-recognition'
