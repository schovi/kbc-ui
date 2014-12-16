Immutable = require 'immutable'
EventEmitter = require('events').EventEmitter
List = Immutable.List
_ = require 'underscore'

api = require './EventsApi.coffee'
CHANGE_EVENT = 'change'

class EventsService

  constructor: (@api, @defaultParams) ->
    @_emmiter = new EventEmitter()

  _reset = ->
    @_events = List()
    @_isLoading = false
    @_loadingOlder = false

  setParams: (params) ->
    @defaultParams = params

  load: ->
    @api
    .listEvents(_.extend {}, @defaultParams,
      limit: 10
    ).then(@_setEvents.bind(@))

  loadNew: ->
    @isLoading = true
    

  loadMore: ->
    @_loadingOlder = true
    @_emitChange()

    @api
    .listEvents(_.extend {}, @defaultParams,
      limit: 10
      maxId: @_events.last().get('id')
    ).then(@_appendEvents.bind(@))

  getEvents: ->
    @_events

  getIsLoadingOlder: ->
    @_loadingOlder

  _setEvents: (events) ->
    console.log 'set events', events
    @_events = Immutable.fromJS(events)
    @_emitChange()

  _appendEvents: (events) ->
    @_loadingOlder = false
    @_events = @_events.concat(Immutable.fromJS(events))
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