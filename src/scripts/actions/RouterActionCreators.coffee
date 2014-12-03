dispatcher = require '../Dispatcher.coffee'
constants = require '../constants/KbcConstants.coffee'

module.exports =

  routesConfigurationReceive: (routes) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ROUTER_ROUTES_CONFIGURATION_RECEIVE
      routes: routes
    )

  routeChange: (routerState) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ROUTER_ROUTE_CHANGED
      routerState: routerState
    )