React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
InstalledComponentsActionCreators = require '../../../../components/InstalledComponentsActionCreators'
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
TransformationTypeLabel = React.createFactory(require '../../components/TransformationTypeLabel')
DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')
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

    buttons.push(RunComponentButton(
      title: "Run #{@props.transformation.get('friendlyName')}"
      component: 'transformation'
      mode: 'button'
      runParams: ->
        configBucketId: props.bucket.get('id')
        transformations: [props.transformation.get('id')]
    ,
      "You are about to run transformation #{@props.transformation.get('friendlyName')}."
    ))

    buttons.push(DeleteButton
      tooltip: 'Delete Transformation'
      isPending: @props.pendingActions.get 'delete'
      confirm:
        title: 'Delete Transformation'
        text: "Do you really want to delete transformation #{@props.transformation.get('friendlyName')}?"
        onConfirm: @_deleteTransformation
    )
    buttons

  render: ->
    Link
      className: 'tr'
      to: 'transformationDetail'
      params: {transformationId: @props.transformation.get('id'), bucketId: @props.bucket.get('id')}
    ,
      span {className: 'td'},
        span {className: 'label kbc-label-rounded-small label-default pull-left'},
          @props.transformation.get('phase') || 1
        h4 {},
          @props.transformation.get('friendlyName') || @props.transformation.get('id')
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

)

module.exports = TransformationRow
