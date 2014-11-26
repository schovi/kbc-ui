React = require 'react'

ComponentsStore = require '../../../stores/ComponentsStore.coffee'

{Panel, PanelGroup} = require('react-bootstrap')
Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup

JobTask = React.createClass
  displayName: 'JobTask'
  propTypes:
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object

  render: ->
    Panel React.__spread({}, @proprs, header: @_header()),
      @props.task.startTime

  _header: ->
    if @props.component
      @props.component.get 'name'
    else
      @props.task.componentUrl


JobTasks = React.createClass
  displayName: 'JobTasks'
  propTypes:
    tasks: React.PropTypes.array.isRequired

  getInitialState: ->
    components: ComponentsStore.getAll()

  render: ->
    PanelGroup accordion: true, @_renderTasks()

  _renderTasks: ->
    @props.tasks.map(@_renderTask, @)

  _renderTask: (task) ->
    Panel header: task.component, key: task.id, eventKey: task.id,
      task.startTime


module.exports = JobTasks