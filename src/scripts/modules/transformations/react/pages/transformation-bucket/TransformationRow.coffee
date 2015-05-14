React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
InstalledComponentsActionCreators = require '../../../../components/InstalledComponentsActionCreators'
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
TransformationTypeLabel = React.createFactory(require '../../components/TransformationTypeLabel')
DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')
ActivateDeactivateButton = React.createFactory(require '../../../../../react/common/ActivateDeactivateButton')

TransformationsActionCreators = require '../../../ActionCreators'

{span, div, a, button, i, h4, small, em} = React.DOM

TransformationRow = React.createClass(
  displayName: 'TransformationRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    transformation: React.PropTypes.object
    bucket: React.PropTypes.object
    pendingActions: React.PropTypes.object

  buttons: ->
    buttons = []
    props = @props

    buttons.push(DeleteButton
      tooltip: 'Delete Transformation'
      isPending: @props.pendingActions.get 'delete'
      confirm:
        title: 'Delete Transformation'
        text: "Do you really want to delete transformation #{@props.transformation.get('name')}?"
        onConfirm: @_deleteTransformation
    )

    buttons.push ActivateDeactivateButton
      activateTooltip: 'Enable Transformation'
      deactivateTooltip: 'Disable Transformation'
      isActive: !@props.transformation.get('disabled')
      isPending: @props.pendingActions.has 'change-disabled'
      onChange: @_handleActiveChange

    buttons.push(RunComponentButton(
      title: "Run #{@props.transformation.get('name')}"
      component: 'transformation'
      mode: 'button'
      runParams: ->
        configBucketId: props.bucket.get('id')
        transformations: [props.transformation.get('id')]
    ,
      "You are about to run transformation #{@props.transformation.get('name')}."
    ))


    buttons

  render: ->
    # TODO - no detail for unsupported transformations! (remote, db/snapshot, ...)
    Link
      className: 'tr'
      to: 'transformationDetail'
      params: {transformationId: @props.transformation.get('id'), bucketId: @props.bucket.get('id')}
    ,
      span {className: 'td'},
        h4 {},
        span {className: 'label kbc-label-rounded-small label-default pull-left'},
          @props.transformation.get('phase') || 1
        ' '
        @props.transformation.get('name')
      span {className: 'td'},
        small {}, @props.transformation.get('description') || em {}, 'No description'
      span {className: 'td'},
        TransformationTypeLabel
          backend: @props.transformation.get 'backend'
          type: @props.transformation.get 'type'
      span {className: 'td text-right'},
        @buttons()

  _deleteTransformation: ->
    # if transformation is deleted immediately view is rendered with missing bucket because of store changed
    transformationId = @props.transformation.get('id')
    bucketId = @props.bucket.get('id')
    setTimeout ->
      TransformationsActionCreators.deleteTransformation(bucketId, transformationId)

  _handleActiveChange: (newValue) ->
    transformationId = @props.transformation.get('id')
    bucketId = @props.bucket.get('id')
    TransformationsActionCreators.changeTransformationProperty(bucketId, transformationId, 'disabled', !newValue)
)

module.exports = TransformationRow
