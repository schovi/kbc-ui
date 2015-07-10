React = require 'react'

Link = React.createFactory(require('react-router').Link)
EditButtons = React.createFactory(require('../../../../react/common/EditButtons'))
TransformationsActionCreators = require '../../ActionCreators'
RoutesStore = require '../../../../stores/RoutesStore'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../stores/TransformationsStore')

{button, span} = React.DOM

TransformationDetailButtons = React.createClass
  displayName: 'TransformationDetailButtons'
  mixins: [
    createStoreMixin(TransformationsStore)
  ]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    bucketId = RoutesStore.getCurrentRouteParam 'bucketId'
    transformationId = RoutesStore.getCurrentRouteParam 'transformationId'
    bucketId: bucketId
    transformationId: transformationId
    transformation: TransformationsStore.getTransformation(bucketId, transformationId)
    isEditing: TransformationsStore.isEditing(bucketId, transformationId)
    isSaving: TransformationsStore.isSaving(bucketId, transformationId)

  render: ->
    span {},
      EditButtons
        isEditing: @state.isEditing
        isSaving: @state.isSaving
        isDisabled: false
        onCancel: @_handleEditCancel
        onSave: @_handleEditSave
        onEditStart: @_handleEditStart
        editLabel: 'Edit transformation'

  _handleEditStart: ->
    TransformationsActionCreators.startTransformationEdit(@state.bucketId, @state.transformationId)

  _handleEditSave: ->
    TransformationsActionCreators.saveTransformationEdit(@state.bucketId, @state.transformationId)

  _handleEditCancel: ->
    TransformationsActionCreators.cancelTransformationEdit(@state.bucketId, @state.transformationId)

  _showDetails: ->
    @state.transformation.get('backend') == 'mysql' and @state.transformation.get('type') == 'simple' or
    @state.transformation.get('backend') == 'redshift' and @state.transformation.get('type') == 'simple' or
    @state.transformation.get('backend') == 'docker' and @state.transformation.get('type') == 'r'

module.exports = TransformationDetailButtons
