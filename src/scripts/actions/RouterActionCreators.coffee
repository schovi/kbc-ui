dispatcher = require '../Dispatcher'
constants = require '../constants/KbcConstants'

module.exports =

  routesConfigurationReceive: (routes) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ROUTER_ROUTES_CONFIGURATION_RECEIVE
      routes: routes
    )

  routeChangeStart: (newRouterState) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ROUTER_ROUTE_CHANGE_START
      routerState: newRouterState
    )

  routeChangeSuccess: (routerState) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ROUTER_ROUTE_CHANGE_SUCCESS
      routerState: routerState
    )

  routeChangeError: (error) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ROUTER_ROUTE_CHANGE_ERROR
      error: error
    )