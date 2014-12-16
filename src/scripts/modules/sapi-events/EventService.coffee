Immutable = require 'immutable'
EventEmitter = require('events').EventEmitter
List = Immutable.List
_ = require 'underscore'

api = require './EventsApi.coffee'
CHANGE_EVENT = 'change'

class EventsService

  constructor: (@api, @defaultParams) ->
    @_events = List
    @_emmiter = new EventEmitter()

  setParams: (params) ->
    @defaultParams = params

  load: ->
    @api
    .listEvents(_.extend {}, @defaultParams,
      limit: 10
    ).then(@_setEvents.bind(@))


  loadMore: ->
    # todo

  getEvents: ->
    @_events

  _setEvents: (events) ->
    console.log 'set events', events
    @_events = Immutable.fromJS(events)
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