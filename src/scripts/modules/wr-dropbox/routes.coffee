IndexPage = require './react/pages/index/Index'
installedComponentsActions = require '../components/InstalledComponentsActionCreators'
installedComponentsStore = require '../components/stores/InstalledComponentsStore'
oauthStore = require('../components/stores/OAuthStore')
oauthActions = require('../components/OAuthActionCreators')

Immutable = require 'immutable'
RouterStore = require('../../stores/RoutesStore')
{Navigation} = require 'react-router'
ApplicationActionCreators = require('../../actions/ApplicationActionCreators')
JobsActionCreators = require '../jobs/ActionCreators'

module.exports =
  name: 'wr-dropbox'
  path: 'wr-dropbox/:config'
  isComponent: true
  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData('wr-dropbox', params.config)
    (params) ->
      oauthActions.loadCredentials('wr-dropbox', params.config)
  ]
  poll:
    interval: 7
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs('wr-dropbox', params.config)
  defaultRouteHandler: IndexPage
  childRoutes: [
    name: 'wr-dropbox-oauth-redirect'
    path: 'oauth-redirect'
    title: ''
    requireData: [
      (params) ->
        installedComponentsActions.loadComponentConfigData('wr-dropbox', params.config).then ->
          configuration = installedComponentsStore.getConfigData('wr-dropbox', params.config).toJS()
          oauthActions.loadCredentials('wr-dropbox', params.config).then ->
            credentials = oauthStore.getCredentials('wr-dropbox', params.config).toJS()
            parameters = configuration?.parameters or {}
            # save credentials id as this configId to its configuration
            parameters.credentials = params.config
            configuration.parameters = parameters
            description = credentials?.description
            saveFn = installedComponentsActions.saveComponentConfigData
            saveFn('wr-dropbox', params.config, Immutable.fromJS(configuration)).then ->
              router = RouterStore.getRouter()
              notification = "Dropbox account #{description} succesfully authorized."
              ApplicationActionCreators.sendNotification
                message: notification
              router.transitionTo('wr-dropbox', config: params.config)
          , (err) ->
            notification = 'Failed to authorize the Dropbox account, please contact us on support@keboola.com'
            ApplicationActionCreators.sendNotification
              message: notification
              type: 'error'
            router.transitionTo('wr-dropbox', config: params.config)



  ]


  ]
