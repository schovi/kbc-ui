React = require 'react'

ComponentsStore = require '../../../../components/stores/ComponentsStore'
{span, div, strong, h5} = React.DOM
{Panel, PanelGroup} = require('react-bootstrap')
Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup
ComponentConfigurationLink = require '../../../../components/react/components/ComponentConfigurationLink'

kbCommon = require '../../../../../react/common/common'
ComponentIcon = React.createFactory(kbCommon.ComponentIcon)
ComponentName = React.createFactory(kbCommon.ComponentName)
Duration = React.createFactory(kbCommon.Duration)
Tree = React.createFactory(require('kbc-react-components').Tree)
JobStatusLabel = React.createFactory(kbCommon.JobStatusLabel)

date = require '../../../../../utils/date'

JobTasks = React.createClass
  displayName: 'JobTasks'
  propTypes:
    tasks: React.PropTypes.object.isRequired

  getInitialState: ->
    components: ComponentsStore.getAll()

  render: ->
    PanelGroup
      accordion: true
      className: 'kbc-panel-heading-with-table'
      @_renderTasks()

  _renderTasks: ->
    @props.tasks
    .filter (task) -> task.get('active')
    .map(@_renderTask, @).toArray()

  _renderTask: (task) ->
    component = @state.components.get(task.get('component'))
    header = span null,
      span className: 'table',
        span className: 'tbody',
          span className: 'tr',
            span className: 'td col-xs-7',
              if component
                span {},
                  ComponentIcon size: '32', component: component
                  ' '
                  ComponentName component: component
              else
                task.get 'componentUrl'
              ' '
              if task.has 'config'
                ' - ' + task.getIn ['config', 'name']
            span className: 'td col-xs-1 text-right',
              span className: 'label kbc-label-rounded label-default',
                task.get('phase')
            span className: 'td col-xs-2 text-right',
              Duration startTime: task.get('startTime'), endTime: task.get('endTime')
            span className: 'td col-xs-2 text-right',
              JobStatusLabel status: task.get('status') if task.has('status')

    Panel
      header: header
      key: task.get('id')
      eventKey: task.get('id')
    ,
      div(className: 'pull-right', date.format(task.get('startTime'))) if task.get('startTime')
      if task.has 'config'
        div null,
          strong null, 'Configuration '
          React.createElement ComponentConfigurationLink,
            componentId: task.get('component')
            configId: task.getIn ['config', 'id']
          ,
            task.getIn ['config', 'name']
      div(null, strong(null, 'POST'), ' ', task.get('runUrl')) if task.get('runUrl')
      if task.get('runParameters')?.size
        div null,
          h5 null, 'Parameters'
          Tree data: task.get('runParameters')
      if task.get('response')?.size
        div null,
          h5(null, 'Response'),
          Tree data: task.get('response')


module.exports = JobTasks
