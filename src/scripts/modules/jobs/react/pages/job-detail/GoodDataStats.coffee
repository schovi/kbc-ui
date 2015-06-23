React = require 'react'
_ = require 'underscore'

{div} = React.DOM

module.exports = React.createClass
  displayName: 'GoodDataResultStats'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    events: React.PropTypes.object.isRequired

  componentDidMount: ->
    console.log "TASKS", @props.tasks.toJS()
    @props.events.load().then (result) =>
      console.log "loaded", result
      console.log "EVENTS", @props.events.getEvents().toJS()
      @_getTasksResults()

  render: ->
    div null, 'stats detail'


  _getTasksResults: ->
    events = @props.events.getEvents().toJS()
    tasks = @props.tasks.toJS()
    _.each tasks, (task, taskId) ->
      msg = "Task #{taskId} "
      console.log "task", task, taskId, msg

      result = _.filter _.values(events), (event) ->
        #console.log event.message, msg, _.str.startsWith(event.message, msg)
        _.str.startsWith event.message, msg
      console.log "filter result", result
