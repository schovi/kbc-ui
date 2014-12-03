
Dispatcher = require('../Dispatcher.coffee')
Immutable = require 'immutable'
Map = Immutable.Map
List = Immutable.List
StoreUtils = require '../utils/StoreUtils.coffee'
_ = require 'underscore'

Immutable = require('immutable')
Constants = require '../constants/KbcConstants.coffee'

_store = Map(
  routerState: Map()
  routesByName: Map()
)

###
  Converts nested routes structure to flat Map indexed by route name
###
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
getRouteTitle = (store, routeName) ->
  title = store.getIn ['routesByName', routeName, 'title'], List()

  if _.isFunction title
    title(store.get 'routerState')
  else
    title

getCurrentRouteName = (store) ->
  routes = store.getIn ['routerState', 'routes'], List()
  route = routes.findLast((route) ->
    !!route.get('name')
  )
  if route
    route.get 'name'
  else
    null

generateBreadcrumbs = (store) ->
  currentParams = store.getIn ['routerState', 'params']
  store.getIn(['routerState', 'routes'], List())
    .shift()
    .filter((route) -> !!route.get 'name')
    .map((route) ->
      Map(
        title: getRouteTitle(store, route.get 'name')
        name: route.get 'name'
        link: Map(
          to: route.get 'name'
          params: currentParams
        )
      )
    )


RoutesStore = StoreUtils.createStore

  getBreadcrumbs: ->
    generateBreadcrumbs(_store)

  getCurrentRouteConfig: ->
    _store.getIn ['routesByName', getCurrentRouteName(_store)]


  getRequireDataFunctionsForRouterState: (routes) ->
    Immutable
      .fromJS(routes)
      .map((route) ->
        _store.getIn ['routesByName', route.get('name'), 'requireData']
      )
      .filter((func) -> _.isFunction func)

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.ROUTER_ROUTE_CHANGED
      _store = _store.set 'routerState', Immutable.fromJS(action.routerState)

    when Constants.ActionTypes.ROUTER_ROUTES_CONFIGURATION_RECEIVE
      _store = _store.set 'routesByName', nestedRoutesToByNameMap(action.routes)

  # Emit change on events
  # for example orchestration is loaed asynchronously while breadcrumbs are already rendered so it has to be rendered again
  RoutesStore.emitChange()


module.exports = RoutesStore