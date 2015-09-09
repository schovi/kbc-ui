React = require 'react'
createStoreMixin = require('../../../../react/mixins/createStoreMixin')
ComponentsStore = require ('../../../components/stores/ComponentsStore')

#TaskSelectTable = React.createFactory(require '../components/TaskSelectTable')
TaskSelectTable = require '../components/TaskSelectTable'


{Modal, Button, Panel} = require('react-bootstrap')
{div, p, strong, form, input, label} = React.DOM

Panel  = React.createFactory Panel
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
      bsSize: "large"
      keyboard: false
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        p null,
          'You are about to run orchestration again'
        Panel
          header: 'Choose orchestration tasks to run'
          collapsible: true
        ,
          div className: 'row',
            React.createElement TaskSelectTable,
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
              onSave: @_handleRun

  _handleRun: (e) ->
    @props.onRun()
    @props.onRequestHide()

  _handleTaskUpdate: (updatedTask) ->
    @props.onChange(updatedTask)