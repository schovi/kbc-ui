React = require 'react'
Immutable = require 'immutable'
common = require '../../../../../react/common/common'
_ = require 'underscore'

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
ComponentConfigurationLink = require '../../../../components/react/components/ComponentConfigurationLink'

TaskParametersEditModal = React.createFactory(require '../../modals/TaskParametersEdit')
ComponentIcon = React.createFactory(common.ComponentIcon)
ComponentName = React.createFactory(common.ComponentName)
Tree = React.createFactory(require('kbc-react-components').Tree)
Check = React.createFactory(common.Check)
Tooltip = React.createFactory(require('../../../../../react/common/Tooltip').default)

{small, button, tr, td, span, div, i, input} = React.DOM

TasksEditTableRow = React.createClass
  displayName: 'TasksEditTableRow'
  propTypes:
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object
    disabled: React.PropTypes.bool.isRequired
    onTaskDelete: React.PropTypes.func.isRequired
    onTaskUpdate: React.PropTypes.func.isRequired
    toggleMarkTask: React.PropTypes.func.isRequired
    isDraggingPhase: React.PropTypes.bool.isRequired
    isMarked: React.PropTypes.bool.isRequired
    onAddNewTask: React.PropTypes.func.isRequired

  render: ->
    tr null,
      td className: 'kb-orchestrator-task-drag text-center',
        input
          type: 'checkbox'
          checked: @props.isMarked
          onClick: =>
            @props.toggleMarkTask(@props.task.get('id'))
      td null,
        span className: 'kbc-component-icon',
          if @props.component
            ComponentIcon component: @props.component
          else
            ' '

        if @props.component
          ComponentName component: @props.component
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
        div className: 'form-group form-group-sm',
          input
            className: 'form-control'
            type: 'text'
            defaultValue: @props.task.get('action')
            disabled: @props.disabled
            onChange: @_handleActionChange
      td null,
        input
          type: 'checkbox'
          disabled: @props.disabled
          checked: @props.task.get('active')
          onChange: @_handleActiveChange
      td null,
        input
          type: 'checkbox'
          disabled: @props.disabled
          checked: @props.task.get('continueOnFailure')
          onChange: @_handleContinueOnFailureChange
      @_renderActionButtons()


  _renderActionButtons: ->
    moreStyle =
      padding: '2px'
      position: 'relative'
      top: '+2px'
    td className: 'text-right kbc-no-wrap',
      div className: '',
        ModalTrigger
          modal: TaskParametersEditModal(
            onSet: @_handleParametersChange, parameters: @props.task.get('actionParameters').toJS())
        ,

          button
            style: moreStyle
            className: 'btn btn-link'
          ,
            Tooltip
              placement: 'top'
              tooltip: 'Task parameters'
              span className: 'fa fa-fw fa-ellipsis-h fa-lg'
        button
          style: {padding: '2px'}
          onClick: @_handleDelete
          className: 'btn btn-link'
        ,
          Tooltip
            placement: 'top'
            tooltip: 'Remove task'
            span className: 'kbc-icon-cup'

  _handleParametersChange: (parameters) ->
    @props.onTaskUpdate @props.task.set('actionParameters', Immutable.fromJS(parameters))

  _handleActionChange: (event) ->
    @props.onTaskUpdate @props.task.set('action', event.target.value.trim())

  _handleActiveChange: ->
    @props.onTaskUpdate @props.task.set('active', !@props.task.get('active'))

  _handleContinueOnFailureChange: ->
    @props.onTaskUpdate @props.task.set('continueOnFailure', !@props.task.get('continueOnFailure'))

  _handleDelete: ->
    @props.onTaskDelete(@props.task.get('id'))


module.exports = TasksEditTableRow
