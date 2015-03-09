React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
InstalledComponentsActionCreators = require '../../../../components/InstalledComponentsActionCreators'
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')
TransformationActionCreators = require '../../../ActionCreators'

{span, div, a, button, i, h4, small} = React.DOM

TransformationBucketRow = React.createClass(
  displayName: 'TransformationBucketRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    bucket: React.PropTypes.object
    pendingActions: React.PropTypes.object
    description: React.PropTypes.string

  buttons: ->
    buttons = []
    props = @props

    buttons.push(RunComponentButton(
      title: "Run #{@props.bucket.get('name')}"
      component: 'transformation'
      mode: 'button'
      runParams: ->
        configBucketId: props.bucket.get('id')
      key: 'run'
    ,
      "You are about to run all transformations in bucket #{@props.bucket.get('name')}."
    ))

    buttons.push(DeleteButton
      tooltip: 'Delete Transformation Bucket'
      isPending: @props.pendingActions.get 'delete'
      confirm:
        title: 'Delete Transformation Bucket'
        text: "Do you really want to delete transformation bucket #{@props.bucket.get('name')}?"
        onConfirm: @_deleteTransformationBucket
      isEnabled: @props.bucket.get('transformationsCount') == 0
      key: 'delete-new'
    )

    buttons

  render: ->
    Link {className: 'tr', to: 'transformationBucket', params: {bucketId: @props.bucket.get('id')}},
      span {className: 'td'},
        h4 {}, @props.bucket.get('name')
      span {className: 'td'},
        small {}, @props.description || em {}, 'No description'
      span {className: 'td'},
        @buttons()

  _deleteTransformationBucket: ->
    # if transformation is deleted immediately view is rendered with missing bucket because of store changed
    bucketId = @props.bucket.get('id')
    TransformationActionCreators.deleteTransformationBucket(bucketId)


)

module.exports = TransformationBucketRow
