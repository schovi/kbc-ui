Index = require './react/pages/index/Index'
actions = require './wrGdriveActionCreators'

module.exports =
  name: 'wr-google-drive'
  path: 'wr-google-drive/:config'
  isComponent: true
  defaultRouteHandler: Index
  requireData: (params) ->
    actions.loadFiles(params.config)
