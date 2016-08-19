Immutable = require 'immutable'
EventEmitter = require('events').EventEmitter
Map = Immutable.Map
_ = require 'underscore'
timer = require '../../utils/Timer'

api = require './EventsApi'
CHANGE_EVENT = 'change'

class EventsService

  constructor: (@api, @defaultParams) ->
    @_emmiter = new EventEmitter()
    @_autoReload = false
    @reset()

  reset: ->
    @_events = Map()
    @_query = ''
    @_isLoading = false
    @_loadingEvents = Map()
    @_loadingOlder = false
    @_hasMore = true
    @_timer = timer
    @stopAutoReload()
    @_emitChange()
    @_limit = 50

  setParams: (params) ->
    @defaultParams = params
    @reset()

  setQuery: (query) ->
    @_query = query

  setLimit: (limit) ->
    @_limit = limit

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

  loadEvent: (id) ->
    id = parseInt(id)

    if @_events.has(id)
      return

    @_loadingEvents = @_loadingEvents.set id, true
    @api
    .getEvent(id)
    .then (event) =>
      @_loadingEvents = @_loadingEvents.delete id
      @_appendEvents [event]
    .catch =>
      @_loadingEvents = @_loadingEvents.delete id

  load: ->
    @_isLoading = true
    @_emitChange()

    @_listEvents()
    .then(@_setEvents.bind(@))
    .catch @_onError.bind(@)

  loadNew: =>
    @_isLoading = true
    @_emitChange()
    @_listEvents(
      limit: 10
      sinceId: @getEvents().first()?.get('id')
    )
    .then(@_prependEvents.bind(@))
    .catch @_onError.bind(@)

  loadMore: ->
    @_loadingOlder = true
    @_emitChange()

    @_listEvents(
      maxId: @getEvents().last().get('id')
    ).then(@_appendEvents.bind(@))
    .catch @_onError.bind(@)


  _onError: (error) ->
    @_loadingOlder = false
    @_isLoading = false
    @_emitChange()

  _getParams: ->
    _.extend {}, @defaultParams,
      q: @_query
      limit: @_limit

  _listEvents: (params) ->
    @api
    .listEvents(_.extend {}, @_getParams(), params)

  getEvents: ->
    @_events
    .toSeq()
    .sortBy (event) -> event.get('id') * -1

  getEvent: (id) ->
    @_events.get parseInt(id)

  getIsLoadingOlder: ->
    @_loadingOlder

  getIsLoading: ->
    @_isLoading

  getIsLoadingEvent: (id) ->
    @_loadingEvents.has parseInt(id)

  getHasMore: ->
    @_hasMore

  getQuery: ->
    @_query

  _setEvents: (events) ->
    @_isLoading = false
    @_events = @_convertEvents(events)
    @_emitChange()

  _prependEvents: (events) ->
    @_isLoading = false
    if events.length
      @_events = @_events.merge(@_convertEvents(events))
    @_emitChange()

  _appendEvents: (events) ->
    @_loadingOlder = false
    @_events = @_events.merge(@_convertEvents(events))
    @_hasMore = false if !events.length
    @_emitChange()

  _convertEvents: (eventsRaw) ->
    Immutable
    .fromJS(eventsRaw)
    .toMap()
    .mapKeys (key, event) ->
      event.get 'id'

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
