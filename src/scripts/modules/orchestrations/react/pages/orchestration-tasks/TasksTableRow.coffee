React = require 'react'
{ComponentIcon, ComponentName} = require '../../../../../react/common/common'
ComponentConfigurationLink = require '../../../../components/react/components/ComponentConfigurationLink'

OrchestrationTaskRunButton = React.createFactory(require('../../components/OrchestrationTaskRunButton').default)

{Tree, Check} = require 'kbc-react-components'

{tr, td, span, button, i} = React.DOM

module.exports = React.createClass
  displayName: 'TasksTableRow'
  propTypes:
    orchestration: React.PropTypes.object.isRequired
    onRun: React.PropTypes.func.isRequired
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object

  render: ->
    tr null,
      td null,
        span className: 'kbc-component-icon',
          if @props.component
            React.createElement ComponentIcon, component: @props.component
          else
            ' '

        if @props.component
          React.createElement ComponentName, component: @props.component
        else
          @props.task.get('componentUrl')
      td null,
        if @props.task.has 'config'
          React.createElement ComponentConfigurationLink,
            componentId: @props.task.get 'component'
            configId: @props.task.getIn ['config', 'id']
          ,
            @props.task.getIn ['config', 'name']
        else
          'N/A'
      td null,
        span className: 'label label-info',
          @props.task.get('action')
      td null,
        React.createElement Tree, data: @props.task.get('actionParameters')
      td null,
        React.createElement Check, isChecked: @props.task.get('active')
      td null,
        React.createElement Check, isChecked: @props.task.get('continueOnFailure')
      td null,
        OrchestrationTaskRunButton
          orchestration: @props.orchestration
          onRun: @props.onRun
          task: @props.task
          notify: true
          key: 'run'
