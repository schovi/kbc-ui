IndexPage = require './react/pages/index/Index'
installedComponentsActions = require '../components/InstalledComponentsActionCreators'
oauthActions = require('./OAuthActionCreators')

module.exports =
  name: 'wr-dropbox'
  path: 'wr-dropbox/:config'
  isComponent: true
  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData 'wr-dropbox', params.config
    (params) ->
      oauthActions.loadCredentials('wr-dropbox', params.config).then (result) ->

  ]
  defaultRouteHandler: IndexPage
