React = require 'react'
Link = React.createFactory(require('react-router').Link)
TransformationBucketDeleteButton = React.createFactory(require '../../components/TransformationBucketDeleteButton')
TransformationBucketRunButton = React.createFactory(require '../../components/TransformationBucketRunButton')
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

TransformationActionCreators = require '../../../ActionCreators'

{span, div, a, button, i, h4, small} = React.DOM

TransformationBucketRow = React.createClass(
  displayName: 'TransformationBucketRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    bucket: React.PropTypes.object
    pendingActions: React.PropTypes.object

  buttons: ->
    buttons = []

    buttons.push(TransformationBucketDeleteButton(
      bucket: @props.bucket
      isPending: @props.pendingActions.get('delete', false)
      enabled: @props.bucket.get('transformationsCount') == 0
      key: 'delete'
    ))

    buttons.push(TransformationBucketRunButton(
      bucket: @props.bucket
      key: 'run'
    ))

    buttons

  render: ->
    Link {className: 'tr', to: 'transformationBucket', params: {bucketId: @props.bucket.get('id')}},
      span {className: 'td'},
        h4 {}, @props.bucket.get('name')
      span {className: 'td'},
        small {}, @props.bucket.get('description')
      span {className: 'td'},
        @buttons()
)

module.exports = TransformationBucketRow
