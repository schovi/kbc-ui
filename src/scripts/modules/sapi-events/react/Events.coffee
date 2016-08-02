React = require 'react'
Button = React.createFactory(require('react-bootstrap').Button)
Immutable = require 'immutable'
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin'
_ = require 'underscore'
{Link} = require 'react-router'
{div, span, p} = React.DOM

EventService = require('../EventService')
RoutesStore = require '../../../stores/RoutesStore'

SearchRow = React.createFactory(require('../../../react/common/common').SearchRow)
EventsTable = React.createFactory(require './EventsTable')
EventDetail = React.createFactory(require './EventDetail')

Events = React.createClass
  displayName: 'Events'
  mixins: [PureRendererMixin]
  propTypes:
    params: React.PropTypes.object
    autoReload: React.PropTypes.bool
    link: React.PropTypes.object

  _handleChange: ->
    currentEventId = RoutesStore.getRouterState().getIn ['query', 'eventId']
    @_events.loadEvent(currentEventId) if currentEventId

    if @isMounted()
      @setState
        searchQuery: @_events.getQuery()
        events: @_events.getEvents()
        currentEventId: currentEventId
        currentEvent: @_events.getEvent(currentEventId)
        isLoadingCurrentEvent: @_events.getIsLoadingEvent(currentEventId)
        isLoading: @_events.getIsLoading()
        isLoadingOlder: @_events.getIsLoadingOlder()
        hasMore: @_events.getHasMore()

  getInitialState: ->
    events: Immutable.List()
    isLoadingOlder: false
    isLoading: false
    hasMore: true
    searchQuery: ''
    currentEvent: null
    currentEventId: null
    isLoadingCurrentEvent: false

  componentDidMount: ->
    @_createEventsService(@props.params)
    @_events.load()
    @_events.setAutoReload @props.autoReload

    RoutesStore.addChangeListener(@_handleChange)

    if @state.currentEventId
      @_events.loadEvent(@state.currentEventId)

  componentWillReceiveProps: (nextProps) ->
    if !_.isEqual(nextProps.params, @props.params)
      @_destroyEventsService()
      @_createEventsService(nextProps.params)
      @_events.setQuery @state.searchQuery
      @_events.load()


    @_events.setAutoReload nextProps.autoReload

  componentWillUnmount: ->
    @_destroyEventsService()
    RoutesStore.removeChangeListener(@_handleChange)

  _createEventsService: (params) ->
    @_events =  EventService.factory(params)
    @_events.addChangeListener(@_handleChange)

  _destroyEventsService: ->
    @_events.removeChangeListener(@_handleChange)
    @_events.reset()

  render: ->
    div null,
      div null,
        SearchRow
          query: @state.searchQuery
          onSubmit: @_handleQueryChange
        if @state.currentEventId
          if @state.currentEvent
            EventDetail
              link: @props.link
              event: @state.currentEvent
              isLoading: @state.isLoading
          else if @state.isLoadingCurrentEvent
            div className: 'well',
              'Loading event '
          else
            div className: 'well',
              React.createElement Link, @props.link,
                span className: 'fa fa-chevron-left', null
                ' Back'
              p null,
                "Event #{@props.currentEventId} not found."
        else if @state.events.count()
          div null,
            (EventsTable
              isLoading: @state.isLoading
              events: @state.events
              onEventSelect: @_handleEventSelect
              link: @props.link
            ),
            @_renderMoreButton()
        else
          div className: 'well',
            if @state.isLoading
              'Loading ...'
            else
              'No events found'

  _renderMoreButton: ->
    return null if !@state.hasMore

    div className: 'kbc-block-with-padding',
      Button
        bsStyle: 'default'
        onClick: @_handleLoadMore
        disabled: @state.isLoadingOlder
      ,
        if  @state.isLoadingOlder then 'Loading ...' else 'More ...'

  _handleLoadMore: ->
    @_events.loadMore()

  _handleQueryChange: (query) ->
    @_events.setQuery(query)
    @_events.load()


module.exports = Events
