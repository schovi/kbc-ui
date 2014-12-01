
EventEmitter = require('events').EventEmitter
Dispatcher = require('../dispatcher/KbcDispatcher.coffee')
Immutable = require 'immutable'
assign = require 'object-assign'

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

generateBreadcrumbs = (currentRoutes, currentParams) ->
    currentRoutes
      .shift()
      .filter((route) -> !!route.get 'name')
      .map((route, index) ->
        title: _routesByName.getIn [route.get('name'), 'title']
        link:
          to: route.get 'name'
          params: currentParams.toJS()
      ).toJS()

CHANGE_EVENT = 'change'

RoutesStore = assign {}, EventEmitter.prototype,

  getBreadcrumbs: ->
    generateBreadcrumbs(_routerState.get('routes'), _routerState.get('params'))

  addChangeListener: (callback) ->
    @on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(CHANGE_EVENT, callback)

  emitChange: ->
    @emit(CHANGE_EVENT)


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.ROUTER_ROUTE_CHANGED
      _routerState = Immutable.fromJS(action.routerState)
      RoutesStore.emitChange()

    when Constants.ActionTypes.ROUTER_ROUTES_CONFIGURATION_RECEIVE
      _routesByName = nestedRoutesToByNameMap(action.routes)
      RoutesStore.emitChange()


module.exports = RoutesStore