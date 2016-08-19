React = require 'react'
EventsService = require('../../../../sapi-events/EventService').factory
GoodDataStats = React.createFactory(require './GoodDataStats')
_ = require 'underscore'
Immutable = require 'immutable'

module.exports = React.createClass
  displayName: "GoodDataStatsContainer"

  getInitialState: ->
    es = EventsService({runId: @props.job.get('runId')})
    es.setQuery('type:success OR type:error')
    es.setLimit(100)
    eventService: es
    events: Immutable.List()

  propTypes:
    job: React.PropTypes.object.isRequired

  _handleEventsChange: ->
    events = @state.eventService.getEvents()
    @setState
      events: events
    if @props.job.get('isFinished') == true
      @state.eventService.stopAutoReload()
    else
      @state.eventService.startAutoReload()


  componentWillUnmount: ->
    @state.eventService.stopAutoReload()
    @state.eventService.removeChangeListener(@_handleEventsChange)

  componentDidMount: ->
    @state.eventService.addChangeListener(@_handleEventsChange)
    @state.eventService.load()

  render: ->
    GoodDataStats
      tasks: @_getTaskEvents()


  _getTaskEvents: ->
    events = @state.events.toJS()
    tasks = @props.job.getIn(['params', 'tasks']).toJS()
    _.map tasks, (task, taskId) ->
      msg = "Task #{taskId} "
      event = _.find _.values(events), (event) ->
        _.str.startsWith event.message, msg
      task.event = event
      task
