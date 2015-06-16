
React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
immutableMixin = require '../../../../react/mixins/ImmutableRendererMixin'
OrchestrationsStore = require '../../stores/OrchestrationsStore'
actionCreators = require '../../ActionCreators'

InlineEditTextInput = require '../../../../react/common/InlineEditTextInput'

{button, span} = React.DOM
FIELD = 'name'

module.exports = React.createClass
  displayName: "OrchestrationNameEdit"
  mixins: [createStoreMixin(OrchestrationsStore), immutableMixin]
  propTypes:
    orchestrationId: React.PropTypes.number.isRequired

  getStateFromStores: ->
    value: OrchestrationsStore.get(@props.orchestrationId).get FIELD
    editValue: OrchestrationsStore.getEditingValue @props.orchestrationId, FIELD
    isEditing: OrchestrationsStore.isEditing @props.orchestrationId, FIELD
    isSaving: OrchestrationsStore.isSaving @props.orchestrationId, FIELD
    isValid: true

  _handleEditStart: ->
    actionCreators.startOrchestrationFieldEdit @props.orchestrationId, FIELD

  _handleEditCancel: ->
    actionCreators.cancelOrchestrationFieldEdit @props.orchestrationId, FIELD

  _handleEditChange: (newValue) ->
    actionCreators.updateOrchestrationFieldEdit @props.orchestrationId, FIELD, newValue

  _handleEditSubmit: ->
    actionCreators.saveOrchestrationField @props.orchestrationId, FIELD

  render: ->
    React.createElement InlineEditTextInput,
      text: if @state.isEditing then @state.editValue else @state.value
      placeholder: 'Name the component ...'
      tooltipPlacement: 'bottom'
      isSaving: @state.isSaving
      isEditing: @state.isEditing
      isValid: @state.editValue?.trim() != ''
      onEditStart: @_handleEditStart
      onEditCancel: @_handleEditCancel
      onEditChange: @_handleEditChange
      onEditSubmit: @_handleEditSubmit
