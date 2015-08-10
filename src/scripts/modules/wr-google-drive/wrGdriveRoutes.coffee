Index = require './react/pages/index/Index'
actions = require './wrGdriveActionCreators'
authorizePage = require './react/pages/authorize/Authorize'
InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'

module.exports =
  name: 'wr-google-drive'
  isComponent: true
  path: 'wr-google-drive/:config'
  defaultRouteHandler: Index
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    'Google Drive - ' + InstalledComponentsStore.getConfig('wr-google-drive', configId).get 'name'

  requireData: (params) ->
    actions.loadFiles(params.config)
  childRoutes: [
    name: 'wr-google-drive-authorize'
    path: 'authorize'
    handler: authorizePage
    title: ->
      'Authorize Google Drive account'

  ]
