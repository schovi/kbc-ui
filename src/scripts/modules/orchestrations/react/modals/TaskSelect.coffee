React = require 'react'
createStoreMixin = require('../../../../react/mixins/createStoreMixin')
ComponentsStore = require ('../../../components/stores/ComponentsStore')

TaskSelectTable = React.createFactory(require '../components/TaskSelectTable')


{Modal, Button} = require('react-bootstrap')
{div, p, strong, form, input, label} = React.DOM

ConfirmButtons = require('../../../../react/common/ConfirmButtons')

OrchestrationsApi = require('../../OrchestrationsApi')
actionCreators = require('../../ActionCreators')


module.exports = React.createClass
  displayName: 'TaskSelect'
  propTypes:
    job: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    onRun: React.PropTypes.func.isRequired

  getInitialState: ->
    isSaving: false

  render: ->
    tasks = @props.tasks

    React.createElement Modal,
      title: "Retry job"
      keyboard: false
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        p null,
          'You are about to run orchestration again'
        TaskSelectTable
          tasks: tasks
          onTaskUpdate: @_handleTaskUpdate
      div className: 'modal-footer',
        div null,
          div className: 'col-sm-6'
          div className: 'col-sm-6',
            React.createElement ConfirmButtons,
              isSaving: @state.isSaving
              isDisabled: false
              saveLabel: 'Run'
              onCancel: @props.onRequestHide
#              onSave: @props.onRun
              onSave: @_handleRun

  _handleRun: (e) ->
    @state.isSaving = true
    @props.onRun().then @props.onRequestHide()

  _handleTaskUpdate: (updatedTask) ->
    @props.onChange(updatedTask)