dbwrIndex = require './react/pages/index/Index'

module.exports =
  name: 'wr-db'
  path: 'wr-db/:config'
  isComponent: true
  defaultRouteHandler: dbwrIndex
  # requireData: [
  #   (params) ->
  #     ActionCreators.loadConfiguration params.config
  # ]
