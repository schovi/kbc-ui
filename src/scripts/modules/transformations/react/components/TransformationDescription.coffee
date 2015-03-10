React = require 'react'
InlineEditTextArea = require '../../../../react/common/InlineEditArea'
immutableMixin = require '../../../../react/mixins/ImmutableRendererMixin'
TransformationsStore = require '../../stores/TransformationsStore'

module.exports = React.createClass
  displayName: 'TransformationDescription'

  mixins: [createStoreMixin(TransformationsStore), immutableMixin]
  propTypes:
    transformationId: React.PropTypes.string.isRequired
    bucketId: React.PropTypes.string.isRequired

  getStateFromStores: ->
    value: TransformationsStore.getTransformation(@props.bucketId, @props.transformationId).get 'description'
    editValue: TransformationsStore.getEditingConfig @props.bucketId, @props.transformationId, 'description'
    isEditing: TransformationsStore.isEditingConfig @props.bucketId, @props.transformationId, 'description'
    isSaving: TransformationsStore.isSavingConfig @props.componentId, @props.configId, 'description'
    isValid: TransformationsStore.isValidEditingConfig @props.componentId, @props.configId, 'description'

  _handleEditStart: ->
    TransformationsStore.startConfigurationEdit(@props.componentId, @props.configId, @props.fieldName)

  _handleEditCancel: ->
    TransformationsStore.cancelConfigurationEdit(@props.componentId, @props.configId, @props.fieldName)

  _handleEditChange: (newValue) ->
    TransformationsStore.updateEditingConfiguration(
      @props.bucketId,
      @props.transformationId,
      'description',
      newValue
    )

  _handleEditSubmit: ->
    TransformationsStore.saveConfigurationEdit(@props.bucketId, @props.transformationId, 'description')

  render: ->
    React.createElement InlineEditTextArea,
      text: if @state.isEditing then @state.editValue else @state.value
      placeholder: 'Describe the component ...'
      isSaving: @state.isSaving
      isEditing: @state.isEditing
      isValid: @state.isValid
      onEditStart: @_handleEditStart
      onEditCancel: @_handleEditCancel
      onEditChange: @_handleEditChange
      onEditSubmit: @_handleEditSubmit


