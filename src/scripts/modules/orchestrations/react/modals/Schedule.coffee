React = require 'react'
{Modal, Button} = require('react-bootstrap')
ConfirmButtons = require('../../../../react/common/ConfirmButtons').default
CronScheduler = require '../../../../react/common/CronScheduler'

OrchestrationsApi = require '../../OrchestrationsApi'
actionCreators = require '../../ActionCreators'

{div, p, strong, form, input, label} = React.DOM

module.exports = React.createClass
  displayName: 'Schedule'
  propTypes:
    orchestrationId: React.PropTypes.number.isRequired
    crontabRecord: React.PropTypes.string.isRequired

  getInitialState: ->
    crontabRecord: @props.crontabRecord || '0 0 * * *'
    isSaving: false

  render: ->
    React.createElement Modal,
      title: "Orchestration Schedule"
      keyboard: false
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        React.createElement CronScheduler,
          crontabRecord: @state.crontabRecord
          onChange: @_handleCrontabChange
      div className: 'modal-footer',
        div null,
          div className: 'col-sm-6',
            React.createElement Button,
              className: 'pull-left'
              bsStyle: 'danger'
              onClick: @_handleRemoveSchedule
              disabled: @state.isSaving
            ,
              'Remove Schedule'
          div className: 'col-sm-6',
            React.createElement ConfirmButtons,
              isSaving: @state.isSaving
              isDisabled: false
              saveLabel: 'Save'
              onCancel: @props.onRequestHide
              onSave: @_handleSave

  _handleRemoveSchedule: ->
    @_save null

  _handleSave: ->
    @_save @state.crontabRecord

  _save: (crontabRecord) ->
    @setState
      isSaving: true

    OrchestrationsApi
    .updateOrchestration @props.orchestrationId,
      crontabRecord: crontabRecord
    .then @_handleSaveSuccess
    .catch (e) ->
      console.log 'error', e

  _handleSaveSuccess: (response) ->
    actionCreators
    .receiveOrchestration response
    @props.onRequestHide()

  _handleCrontabChange: (newValue) ->
    @setState
      crontabRecord: newValue
