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

  getInitialState: ->
    events: Immutable.List()
    isLoadingOlder: false

  componentDidMount: ->
    console.log 'did mount'
    @_events =  EventService.factory(@props.params)
    @_events.load()
    @_events.addChangeListener(@_handleChange)


  componentWillReceiveProps: (nextProps) ->
    if !_.isEqual(nextProps.params, @props.params)
      @_events.setParams(nextProps.params)
      @_events.load()

  render: ->
    React.DOM.div null,
      EventsTable
        events: @state.events
      Button
        bsStyle: 'default'
        onClick: @_handleLoadMore
        disabled: @state.isLoadingOlder
      ,
        if  @state.isLoadingOlder then 'Loading ...' else 'More ...'

  _handleLoadMore: ->
    @_events.loadMore()

  _handleChange: ->
    console.log 'changed'
    @setState
      events: @_events.getEvents()
      isLoadingOlder: @_events.getIsLoadingOlder()


module.exports = Events