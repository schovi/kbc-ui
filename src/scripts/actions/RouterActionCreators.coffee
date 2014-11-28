dispatcher = require '../dispatcher/KbcDispatcher.coffee'
constants = require '../constants/KbcConstants.coffee'

module.exports =

  routeChange: (routerState) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ROUTER_ROUTE_CHANGED
      routerState: routerState
    )