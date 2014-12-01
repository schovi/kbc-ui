
Dispatcher = require('../dispatcher/KbcDispatcher.coffee')
Immutable = require 'immutable'
StoreUtils = require '../utils/StoreUtils.coffee'
_ = require 'underscore'

Immutable = require('immutable')
Constants = require '../constants/KbcConstants.coffee'

_routerState = {}
_routesByName = Immutable.Map()


nestedRoutesToByNameMap = (route) ->
  map = {}
  traverse  = (route) ->
    if route.name
      map[route.name] = route

    if route.childRoutes
      route.childRoutes.forEach traverse

  traverse(route)
  Immutable.fromJS map

###
 Returns title for route
###
getRouteTitle = (routeName) ->
  title = _routesByName.getIn [routeName, 'title']

  if _.isFunction title
    title(_routerState)
  else
    title

getCurrentRouteName = ->
  routes = _routerState.get('routes')
  route = routes.findLast((route) ->
    !!route.get('name')
  )
  if route
    route.get 'name'
  else
    null

generateBreadcrumbs = (currentRoutes, currentParams) ->
    currentRoutes
      .shift()
      .filter((route) -> !!route.get 'name')
      .map((route) ->
        Immutable.fromJS(
          title: getRouteTitle(route.get 'name')
          name: route.get 'name'
          link:
            to: route.get 'name'
            params: currentParams
        )
      )

RoutesStore = StoreUtils.createStore

  getBreadcrumbs: ->
    generateBreadcrumbs(_routerState.get('routes'), _routerState.get('params'))

  getCurrentRouteConfig: ->
    _routesByName.get(getCurrentRouteName())

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.ROUTER_ROUTE_CHANGED
      _routerState = Immutable.fromJS(action.routerState)

    when Constants.ActionTypes.ROUTER_ROUTES_CONFIGURATION_RECEIVE
      _routesByName = nestedRoutesToByNameMap(action.routes)

  # Emit change on events
  # for example orchestration is loaed asynchronously while breadcrumbs are already rendered so it has to be rendered again
  RoutesStore.emitChange()


module.exports = RoutesStore