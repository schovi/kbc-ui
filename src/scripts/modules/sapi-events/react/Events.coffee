React = require 'react'
Button = React.createFactory(require('react-bootstrap').Button)
Immutable = require 'immutable'

EventService = require('../EventService.coffee')
EventsTable = React.createFactory(require './EventsTable.coffee')

Events = React.createClass
  displayName: 'Events'
  propTypes:
    params: React.PropTypes.object

  getInitialState: ->
    events: Immutable.List()

  componentDidMount: ->
    console.log 'did mount'
    @_events =  EventService.factory(@props.params)
    @_events.load()
    @_events.addChangeListener(@_handleChange)


  componentWillReceiveProps: (nextProps) ->
    console.log 'nextprops', nextProps
    @_events.setParams(nextProps.params)
    @_events.load()

  render: ->
    React.DOM.div null,
      EventsTable
        events: @state.events
      Button
        bsStyle: 'default'
        onClick: @_handleLoadMore
      ,
        'More ...'

  _handleLoadMore: ->
    @_events.loadMore()

  _handleChange: ->
    console.log 'changed'
    @setState
      events: @_events.getEvents()


module.exports = Events