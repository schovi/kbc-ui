
Dispatcher = require('../Dispatcher.coffee')
Immutable = require 'immutable'
Map = Immutable.Map
List = Immutable.List
Error = require '../utils/Error.coffee'
StoreUtils = require '../utils/StoreUtils.coffee'
_ = require 'underscore'

Immutable = require('immutable')
Constants = require '../constants/KbcConstants.coffee'

_store = Map(
  isPending: false
  routerState: Map()
  routesByName: Map()
  breadcrumbs: List()
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
  title = store.getIn ['routesByName', routeName, 'title'], ''

  if !title
    title = store.get('routesByName').find((route) -> route.get('defaultRouteName') == routeName)?.get('title')

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
  if store.has 'error'
    List.of(
      Map(
        name: 'error'
        title: store.get('error').getTitle()
      )
    )
  else
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

  isError: ->
    _store.has 'error'

  getBreadcrumbs: ->
    _store.get 'breadcrumbs'

  getCurrentRouteConfig: ->
    _store.getIn ['routesByName', getCurrentRouteName(_store)]

  getRouterState: ->
    _store.get 'routerState'

  getCurrentRouteParam: (paramName) ->
    @getRouterState().getIn ['params', paramName]

  ###
    Returns if route change is pending
  ###
  getIsPending: ->
    _store.get 'isPending'

  ###
    @return Error
  ###
  getError: ->
    _store.get 'error'

  hasRoute: (routeName) ->
    _store.get('routesByName').has routeName

  getRequireDataFunctionsForRouterState: (routes) ->
    Immutable
      .fromJS(routes)
      .map((route) ->
        requireDataFunctions = _store.getIn ['routesByName', route.get('name'), 'requireData']
        if !Immutable.List.isList(requireDataFunctions)
          requireDataFunctions = Immutable.List.of(requireDataFunctions)
        requireDataFunctions
      )
      .flatten()
      .filter((func) -> _.isFunction func)

  getPollersForRoutes: (routes) ->
    route = Immutable
      .fromJS(routes)
      .filter((route) -> !!route.get 'name')
      .last() # use poller only from last route in hiearchy

    pollerFunctions = _store.getIn ['routesByName', route.get('name'), 'poll'], List()
    if !Immutable.List.isList(pollerFunctions)
      pollerFunctions = Immutable.List.of(pollerFunctions)

    pollerFunctions

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when Constants.ActionTypes.ROUTER_ROUTE_CHANGE_START
      _store = _store.set 'isPending', true

    when Constants.ActionTypes.ROUTER_ROUTE_CHANGE_SUCCESS
      _store = _store.withMutations (store) ->
        newState = Immutable.fromJS(action.routerState)
        notFound = newState.get('routes').last().get('name') == 'notFound'

        store = store.set 'isPending', false
        if notFound
          store
            .set 'error', new Error('Page not found', 'Page not found')
            .set 'routerState', newState
        else
          store
            .remove 'error'
            .set 'routerState', newState

        store.set 'breadcrumbs', generateBreadcrumbs(store)

    when Constants.ActionTypes.ROUTER_ROUTE_CHANGE_ERROR
      _store = _store.withMutations (store) ->
        store = store
          .set 'isPending', false
          .set 'error', Error.fromXhrError(action.error)

        store.set 'breadcrumbs', generateBreadcrumbs(store)

    when Constants.ActionTypes.ROUTER_ROUTES_CONFIGURATION_RECEIVE
      _store = _store.set 'routesByName', nestedRoutesToByNameMap(action.routes)

  # Emit change on events
  # for example orchestration is loaed asynchronously while breadcrumbs are already rendered so it has to be rendered again
  RoutesStore.emitChange()


module.exports = RoutesStore