React = require 'react'

ComponentsStore = require '../../../components/stores/ComponentsStore.coffee'
{span} = React.DOM
{Panel, PanelGroup} = require('react-bootstrap')
Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup
ComponentIcon = React.createFactory(require '../../../../components/common/ComponentIcon.coffee')
ComponentName = React.createFactory(require '../../../../components/common/ComponentName.coffee')
Duration = React.createFactory(require '../../../../components/common/Duration.coffee')
JobStatusLabel = React.createFactory(require '../../../../components/common/JobStatusLabel.coffee')

date = require '../../../../utils/date.coffee'

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
    component = @state.components.get(task.get('component'))
    header = span className: 'row',
      span className: 'col-sm-5',
        ComponentIcon size: '32', component: component
        ' '
        ComponentName component: component
      span className: 'col-sm-3',
        Duration startTime: task.get('startTime'), endTime: task.get('endTime')
      span className: 'col-sm-4',
        JobStatusLabel status: task.get('status') if task.has('status')


    Panel
      header: header
      key: task.get('id')
      eventKey: task.get('id')
    ,
      date.format(task.get('startTime'))


module.exports = JobTasks