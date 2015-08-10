Index = require './react/pages/index/Index'
actions = require './wrGdriveActionCreators'
authorizePage = require './react/pages/authorize/Authorize'

module.exports =
  name: 'wr-google-drive'
  path: 'wr-google-drive/:config'
  isComponent: true
  defaultRouteHandler: Index
  requireData: (params) ->
    actions.loadFiles(params.config)
  childRoutes: [
    name: 'wr-google-drive-authorize'
    path: 'wr-authorize'
    handler: authorizePage
    title: 'Authorize Google Drive account'

  ]
