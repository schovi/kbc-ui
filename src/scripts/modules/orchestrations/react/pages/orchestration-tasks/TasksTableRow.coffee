React = require 'react'
{ComponentIcon, ComponentName} = require '../../../../../react/common/common'
ComponentConfigurationLink = require '../../../../components/react/components/ComponentConfigurationLink'
TaskParametersEditModal = React.createFactory(require '../../modals/TaskParametersEdit')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
Tooltip = React.createFactory(require('../../../../../react/common/Tooltip').default)
OrchestrationTaskRunButton = React.createFactory(require('../../components/OrchestrationTaskRunButton').default)

{Tree, Check} = require 'kbc-react-components'

{small, div, tr, td, span, button, i} = React.DOM

moreStyle =
  padding: '2px'
  position: 'relative'
  top: '+2px'


module.exports = React.createClass
  displayName: 'TasksTableRow'
  propTypes:
    orchestration: React.PropTypes.object.isRequired
    onRun: React.PropTypes.func.isRequired
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object
    color: React.PropTypes.string

  render: ->
    tr {style: {'background-color': @props.color}},
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
            div className: 'help-block',
              small null, @props.task.getIn ['config', 'description']
        else
          'N/A'
      td null,
        span className: 'label label-info',
          @props.task.get('action')
      # td null,
      #   React.createElement Tree, data: @props.task.get('actionParameters')
      td null,
        React.createElement Check, isChecked: @props.task.get('active')
      td null,
        React.createElement Check, isChecked: @props.task.get('continueOnFailure')
      td null,
        div className: 'pull-right',
          ModalTrigger
            modal: TaskParametersEditModal(
              onSet: @_handleParametersChange
              isEditable: false
              parameters: @props.task.get('actionParameters').toJS())
          ,
            button
              style: moreStyle
              className: 'btn btn-link'
            ,
              Tooltip
                placement: 'top'
                tooltip: 'Task parameters'
                span className: 'fa fa-fw fa-ellipsis-h fa-lg'

          OrchestrationTaskRunButton
            buttonStyle: {padding: '+2px'}
            orchestration: @props.orchestration
            onRun: @props.onRun
            task: @props.task
            notify: true
            key: 'run'
