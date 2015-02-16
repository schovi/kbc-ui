React = require 'react'
Immutable = require 'immutable'
common = require '../../../../../react/common/common'
_ = require 'underscore'

DragDropMixin = require('react-dnd').DragDropMixin

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)

TaskParametersEditModal = React.createFactory(require '../../modals/TaskParametersEdit')
ComponentIcon = React.createFactory(common.ComponentIcon)
ComponentName = React.createFactory(common.ComponentName)
Tree = React.createFactory(common.Tree)
Check = React.createFactory(common.Check)

{tr, td, span, div, i, input} = React.DOM

TasksEditTableRow = React.createClass
  displayName: 'TasksEditTableRow'
  mixins: [DragDropMixin]
  propTypes:
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object
    onTaskDelete: React.PropTypes.func.isRequired
    onTaskUpdate: React.PropTypes.func.isRequired
    onTaskMove: React.PropTypes.func.isRequired


  configureDragDrop: (registerType) ->
    row = @
    registerType('task',
      dragSource:
        beginDrag: ->
          item: @props.task
      dropTarget:
        over: (task) ->
          @props.onTaskMove task.get('id'), @props.task.get('id')
    )

  render: ->
    isDragging = @getDragState('task').isDragging
    style =
      cursor: 'move'
      opacity: if isDragging then 0 else

    tr _.extend({style: style}, @dragSourceFor('task'), @dropTargetFor('task')),
      td null,
        i className: 'fa fa-bars'
      td null,
        if @props.component
          ComponentIcon component: @props.component
        else
          ' '
      td null,
        if @props.component
          ComponentName component: @props.component
        else
          @props.task.get('componentUrl')
      td null,
        input
          className: 'form-control'
          type: 'text'
          defaultValue: @props.task.get('action')
          onChange: @_handleActionChange
      td null,
        ModalTrigger
          modal: TaskParametersEditModal(
            onSet: @_handleParametersChange, parameters: @props.task.get('actionParameters').toJS())
        ,
          Tree data: @props.task.get('actionParameters')
      td null,
        input
          type: 'checkbox'
          checked: @props.task.get('active')
          onChange: @_handleActiveChange
      td null,
        input
          type: 'checkbox'
          checked: @props.task.get('continueOnFailure')
          onChange: @_handleContinueOnFailureChange
      td null,
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
