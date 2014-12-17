React = require 'react'
Button = React.createFactory(require('react-bootstrap').Button)
Immutable = require 'immutable'
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin.coffee'
_ = require 'underscore'

{div} = React.DOM

EventService = require('../EventService.coffee')

SearchRow = React.createFactory(require('../../../react/common/common.coffee').SearchRow)
EventsTable = React.createFactory(require './EventsTable.coffee')
EventDetail = React.createFactory(require './EventDetail.coffee')

Events = React.createClass
  displayName: 'Events'
  mixins: [PureRendererMixin]
  propTypes:
    params: React.PropTypes.object
    autoReload: React.PropTypes.bool

  getInitialState: ->
    events: Immutable.List()
    isLoadingOlder: false
    isLoading: false
    hasMore: true
    searchQuery: ''
    selectedEvent: null

  componentDidMount: ->
    @_createEventsService(@props.params)
    @_events.setAutoReload @props.autoReload


  componentWillReceiveProps: (nextProps) ->
    if !_.isEqual(nextProps.params, @props.params)
      @_destroyEventsService()
      @_createEventsService(nextProps.params)

    @_events.setAutoReload nextProps.autoReload

  componentWillUnmount: ->
    @_destroyEventsService()

  _createEventsService: (params) ->
    @_events =  EventService.factory(params)
    @_events.load()
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
        if @state.selectedEvent
          EventDetail
            event: @state.selectedEvent
            onGoBack: @_resetSelectedEvent
        else
          div null,
            (EventsTable
              isLoading: @state.isLoading
              events: @state.events
              onEventSelect: @_handleEventSelect
            ),
            @_renderMoreButton()

  _renderMoreButton: ->
    return null if !@state.hasMore

    Button
      bsStyle: 'default'
      onClick: @_handleLoadMore
      disabled: @state.isLoadingOlder
    ,
      if  @state.isLoadingOlder then 'Loading ...' else 'More ...'

  _handleLoadMore: ->
    @_events.loadMore()

  _handleEventSelect: (selectedEvent) ->
    @setState
      selectedEvent: selectedEvent

  _resetSelectedEvent: ->
    @setState
      selectedEvent: null

  _handleQueryChange: (query) ->
    @_events.setQuery(query)
    @_events.load()
    console.log 'query change', query

  _handleChange: ->
    if @isMounted()
      @setState
        searchQuery: @_events.getQuery()
        events: @_events.getEvents()
        isLoading: @_events.getIsLoading()
        isLoadingOlder: @_events.getIsLoadingOlder()
        hasMore: @_events.getHasMore()


module.exports = Events