React = require 'react'
Button = React.createFactory(require('react-bootstrap').Button)
Immutable = require 'immutable'
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin.coffee'
_ = require 'underscore'

EventService = require('../EventService.coffee')
EventsTable = React.createFactory(require './EventsTable.coffee')

Events = React.createClass
  displayName: 'Events'
  mixins: [PureRendererMixin]
  propTypes:
    params: React.PropTypes.object
    autoReload: React.PropTypes.bool

  getInitialState: ->
    events: Immutable.List()
    isLoadingOlder: false

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
    React.DOM.div null,
      (EventsTable
        isLoading: @state.isLoading
        events: @state.events
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

  _handleChange: ->
    if @isMounted()
      @setState
        events: @_events.getEvents()
        isLoading: @_events.getIsLoading()
        isLoadingOlder: @_events.getIsLoadingOlder()
        hasMore: @_events.getHasMore()


module.exports = Events