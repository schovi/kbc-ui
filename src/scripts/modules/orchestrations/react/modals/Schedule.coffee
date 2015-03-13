React = require 'react'
{Modal} = require('react-bootstrap')
ConfirmButtons = require '../../../../react/common/ConfirmButtons'
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
    crontabRecord: @props.crontabRecord
    isSaving: false

  render: ->
    React.createElement Modal,
      title: "Orchestration Schedule"
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        React.createElement CronScheduler,
          crontabRecord: @state.crontabRecord
          onChange: @_handleCrontabChange
      div className: 'modal-footer',
        React.createElement ConfirmButtons,
          isSaving: @state.isSaving
          isDisabled: false
          onCancel: @props.onRequestHide
          onSave: @_handleSave

  _handleSave: ->
    @setState
      isSaving: true

    OrchestrationsApi
    .updateOrchestration @props.orchestrationId,
      crontabRecord: @state.crontabRecord
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
