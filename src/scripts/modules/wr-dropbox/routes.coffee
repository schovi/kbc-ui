IndexPage = require './react/pages/index/Index'
installedComponentsActions = require '../components/InstalledComponentsActionCreators'
oauthActions = require('./OAuthActionCreators')
Immutable = require 'immutable'
RouterStore = require('../../stores/RoutesStore')
{Navigation} = require 'react-router'
ApplicationActionCreators = require('../../actions/ApplicationActionCreators')

module.exports =
  name: 'wr-dropbox'
  path: 'wr-dropbox/:config'
  isComponent: true
  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData('wr-dropbox', params.config)
  ]
  defaultRouteHandler: IndexPage
  childRoutes: [
    name: 'wr-dropbox-oauth-redirect'
    path: 'oauth-redirect'
    title: ''
    requireData: [
      (params) ->
        installedComponentsActions.loadComponentConfigData('wr-dropbox', params.config).then (configuration) ->
          oauthActions.loadCredentials('wr-dropbox', params.config).then (credentials) ->
            console.log "config credentials", configuration, credentials
            parameters = configuration?.parameters or {}
            # save credentials id as this configId to its configuration
            parameters.credentials = params.config
            configuration.parameters = parameters
            description = credentials?.description
            saveFn = installedComponentsActions.saveComponentConfigData
            saveFn('wr-dropbox', params.config, Immutable.fromJS(configuration)).then ->
              router = RouterStore.getRouter()
              notification = "Dropbox account #{description} succesfully authorized."
              ApplicationActionCreators.sendNotification notification
              router.transitionTo('wr-dropbox', config: params.config)
          , (err) ->
            notification = 'Failed to authorize the Dropbox account, please contact us on support@keboola.com'
            ApplicationActionCreators.sendNotification notification, 'error'
            router.transitionTo('wr-dropbox', config: params.config)



  ]


  ]
