Immutable = require 'immutable'
EventEmitter = require('events').EventEmitter
List = Immutable.List
_ = require 'underscore'
timer = require '../../utils/Timer.coffee'

api = require './EventsApi.coffee'
CHANGE_EVENT = 'change'

class EventsService

  constructor: (@api, @defaultParams) ->
    @_emmiter = new EventEmitter()
    @_autoReload = false
    @reset()

  reset: ->
    @_events = List()
    @_query = ''
    @_isLoading = false
    @_loadingOlder = false
    @_hasMore = true
    @_timer = timer
    @stopAutoReload()
    @_emitChange()

  setParams: (params) ->
    @defaultParams = params
    @reset()

  setQuery: (query) ->
    @_query = query

  setAutoReload: (flag) ->
    if flag
      @startAutoReload()
    else
      @stopAutoReload()

  stopAutoReload: ->
    return if !@_autoReload
    @_autoReload = false
    @_timer.stop(@loadNew)

  startAutoReload: ->
    return if @_autoReload
    @_autoReload = true
    @_timer.poll(@loadNew, 5)

  load: ->
    @_isLoading = true
    @_emitChange()

    @_listEvents(
      limit: 10
    )
    .then(@_setEvents.bind(@))
    .catch @_onError.bind(@)

  loadNew: =>
    @_isLoading = true
    @_emitChange()
    @_listEvents(
      limit: 10
      sinceId: @_events.first()?.get('id')
    )
    .then(@_prependEvents.bind(@))
    .catch @_onError.bind(@)

  loadMore: ->
    @_loadingOlder = true
    @_emitChange()

    @_listEvents(
      maxId: @_events.last().get('id')
    ).then(@_appendEvents.bind(@))
    .catch @_onError.bind(@)


  _onError: (error) ->
    @_loadingOlder = false
    @_isLoading = false
    @_emitChange()

  _getParams: ->
    _.extend {}, @defaultParams,
      q: @_query
      limit: 10

  _listEvents: (params) ->
    @api
    .listEvents(_.extend {}, @_getParams(), params)

  getEvents: ->
    @_events

  getIsLoadingOlder: ->
    @_loadingOlder

  getIsLoading: ->
    @_isLoading

  getHasMore: ->
    @_hasMore

  getQuery: ->
    @_query

  _setEvents: (events) ->
    @_isLoading = false
    @_events = Immutable.fromJS(events)
    @_emitChange()

  _prependEvents: (events) ->
    @_isLoading = false
    @_events = Immutable.fromJS(events).concat(@_events) if events.length
    @_emitChange()

  _appendEvents: (events) ->
    @_loadingOlder = false
    @_events = @_events.concat(Immutable.fromJS(events))
    @_hasMore = false if !events.length
    @_emitChange()

  _emitChange: ->
    @_emmiter.emit(CHANGE_EVENT)

  addChangeListener: (callback) ->
    @_emmiter.on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @_emmiter.removeListener(CHANGE_EVENT, callback)


module.exports =
  EventsService: EventsService
  factory: (params) ->
    new EventsService(api, params)