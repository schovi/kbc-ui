React = require 'react'
Immutable = require 'immutable'
common = require '../../../../../react/common/common'
_ = require 'underscore'

DragDropMixin = require('react-dnd').DragDropMixin

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
ComponentConfigurationLink = require '../../../../components/react/components/ComponentConfigurationLink'

Phase = React.createFactory(require('./Phase').default)

TaskParametersEditModal = React.createFactory(require '../../modals/TaskParametersEdit')
ComponentIcon = React.createFactory(common.ComponentIcon)
ComponentName = React.createFactory(common.ComponentName)
Tree = React.createFactory(require('kbc-react-components').Tree)
Check = React.createFactory(common.Check)

{tr, td, span, div, i, input} = React.DOM

TasksEditTableRow = React.createClass
  displayName: 'TasksEditTableRow'
  mixins: [DragDropMixin]
  propTypes:
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object
    disabled: React.PropTypes.bool.isRequired
    onTaskDelete: React.PropTypes.func.isRequired
    onTaskUpdate: React.PropTypes.func.isRequired
    onTaskMove: React.PropTypes.func.isRequired

  statics:
    configureDragDrop: (register) ->
      register 'task',
        dragSource:
          beginDrag: (component) ->
            item: component.props.task
        dropTarget:
          over: (component, task) ->
            component.props.onTaskMove task.get('id'), component.props.task.get('id')

  render: ->
    isDragging = @getDragState('task').isDragging
    style =
      cursor: 'move'
      opacity: if isDragging then 0.5 else 1

    tr _.extend({style: style}, @dragSourceFor('task'), @dropTargetFor('task')),
      td null,
        i className: 'fa fa-bars'
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
        else
          'N/A'
      td null,
        input
          className: 'form-control'
          type: 'text'
          defaultValue: @props.task.get('action')
          disabled: @props.disabled
          onChange: @_handleActionChange
      td className: 'kbc-cursor-pointer',
        ModalTrigger
          modal: TaskParametersEditModal(
            onSet: @_handleParametersChange, parameters: @props.task.get('actionParameters').toJS())
        ,
          Tree data: @props.task.get('actionParameters')
      td null,
        Phase
          onPhaseUpdate: @props.onTaskUpdate
          task: @props.task
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
      td className: 'kbc-cursor-pointer',
        div className: 'pull-right',
          i className: 'kbc-icon-cup', onClick: @_handleDelete

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
