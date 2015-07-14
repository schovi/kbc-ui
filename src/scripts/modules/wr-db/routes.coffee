dbwrIndex = require './react/pages/index/Index'
ActionCreators = require './actionCreators'
module.exports =
  name: 'wr-db'
  path: 'wr-db/:config'
  isComponent: true
  defaultRouteHandler: dbwrIndex
  requireData: [
    (params) ->
      ActionCreators.loadConfiguration 'mysql', params.config
  ]
