IndexPage = require './react/pages/index/Index'
installedComponentsActions = require '../components/InstalledComponentsActionCreators'

module.exports =
  name: 'wr-dropbox'
  path: 'wr-dropbox/:config'
  isComponent: true
  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData 'wr-dropbox', params.config
  ]
  defaultRouteHandler: IndexPage
