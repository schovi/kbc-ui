React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
InstalledComponentsActionCreators = require '../../../../components/InstalledComponentsActionCreators'
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')
TransformationActionCreators = require '../../../ActionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'

{span, div, a, button, i, h4, small, em} = React.DOM

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

    buttons.push(
      button
        key: 'bucket'
        className: "btn btn-link"
        onClick: (e) ->
          e.preventDefault()
          e.stopPropagation()
          RoutesStore.getRouter().transitionTo("transformationBucket", {bucketId: props.bucket.get('id')})
      ,
        i {className: "fa fa-fw fa-chevron-right"}
    )


    buttons

  render: ->
    span {className: 'tr'},
      span {className: 'td col-xs-4'},
        h4 {}, @props.bucket.get('name')
      span {className: 'td col-xs-5'},
        small {}, @props.description || em {}, 'No description'
      span {className: 'td col-xs-3 text-right kbc-no-wrap'},
        @buttons()

  _deleteTransformationBucket: ->
    # if transformation is deleted immediately view is rendered with missing bucket because of store changed
    bucketId = @props.bucket.get('id')
    TransformationActionCreators.deleteTransformationBucket(bucketId)


)

module.exports = TransformationBucketRow
