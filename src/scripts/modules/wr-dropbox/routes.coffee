IndexPage = require './react/pages/index/Index'
installedComponentsActions = require '../components/InstalledComponentsActionCreators'
installedComponentsStore = require '../components/stores/InstalledComponentsStore'
oauthStore = require('../components/stores/OAuthStore')
oauthActions = require('../components/OAuthActionCreators')
StorageActions = require '../components/StorageActionCreators'
Immutable = require 'immutable'
RouterStore = require('../../stores/RoutesStore')
{Navigation} = require 'react-router'
ApplicationActionCreators = require('../../actions/ApplicationActionCreators')
JobsActionCreators = require '../jobs/ActionCreators'
VersionsActionCreators = require '../components/VersionsActionCreators'

module.exports = (componentId) ->
  name: componentId
  path: ':config'
  isComponent: true
  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData(componentId, params.config)
    (params) ->
      oauthActions.loadCredentials(componentId, params.config)
    (params) -> StorageActions.loadTables()
    (params) ->
      VersionsActionCreators.loadVersions(componentId, params.config)

  ]
  poll:
    interval: 7
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs(componentId, params.config)
  defaultRouteHandler: IndexPage(componentId)
  childRoutes: [
    name: 'wr-dropbox-oauth-redirect' + componentId
    path: 'oauth-redirect'
    title: ''
    requireData: [
      (params) ->
        installedComponentsActions.loadComponentConfigData(componentId, params.config).then ->
          configuration = installedComponentsStore.getConfigData(componentId, params.config).toJS()
          oauthActions.loadCredentials(componentId, params.config).then ->
            credentials = oauthStore.getCredentials(componentId, params.config).toJS()
            parameters = configuration?.parameters or {}
            # save credentials id as this configId to its configuration
            parameters.credentials = params.config
            configuration.parameters = parameters
            description = credentials?.description
            saveFn = installedComponentsActions.saveComponentConfigData
            saveFn(componentId, params.config, Immutable.fromJS(configuration)).then ->
              router = RouterStore.getRouter()
              notification = "Dropbox account #{description} succesfully authorized."
              ApplicationActionCreators.sendNotification
                message: notification
              router.transitionTo(componentId, config: params.config)
          , (err) ->
            notification = 'Failed to authorize the Dropbox account, please contact us on support@keboola.com'
            ApplicationActionCreators.sendNotification
              message: notification
              type: 'error'
            router.transitionTo(componentId, config: params.config)



  ]


  ]
