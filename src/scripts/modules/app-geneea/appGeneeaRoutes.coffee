installedComponentsActions = require '../components/InstalledComponentsActionCreators'
topicDetectionIndex = require '../app-geneea/react/pages/index/Index'
IntalledComponentsStore = require '../components/stores/InstalledComponentsStore'
JobsActionCreators = require '../jobs/ActionCreators'
topicDetectionHeaderButtons = require './react/components/topicDetectionHeaderButtons'

module.exports =
  name: 'geneea-topic-detection'
  path: 'geneea-topic-detection/:config'
  isComponent: true
  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData "geneea-topic-detection", params.config
  ]
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    IntalledComponentsStore.getConfig('geneea-topic-detection', configId).get 'name'
  poll:
    interval: 5
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs('geneea-topic-detection', params.config)
  defaultRouteHandler: topicDetectionIndex
  headerButtonsHandler: topicDetectionHeaderButtons
