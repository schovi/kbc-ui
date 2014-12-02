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
      @props.task.get('startTime')

  _header: ->
    if @props.component
      @props.component.get 'name'
    else
      @props.task.get 'componentUrl'


JobTasks = React.createClass
  displayName: 'JobTasks'
  propTypes:
    tasks: React.PropTypes.object.isRequired

  getInitialState: ->
    components: ComponentsStore.getAll()

  render: ->
    PanelGroup accordion: true, @_renderTasks()

  _renderTasks: ->
    @props.tasks.map(@_renderTask, @).toArray()

  _renderTask: (task) ->
    Panel header: task.get('component'), key: task.get('id'), eventKey: task.get('id'),
      task.get('startTime')


module.exports = JobTasks