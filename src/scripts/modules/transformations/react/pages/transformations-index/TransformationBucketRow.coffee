React = require 'react'
Link = React.createFactory(require('react-router').Link)
TransformationBucketDeleteButton = React.createFactory(require '../../components/TransformationBucketDeleteButton')
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
InstalledComponentsActionCreators = require '../../../../components/InstalledComponentsActionCreators'
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
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
    ,
      "You are about to run all transformations in bucket #{@props.bucket.get('name')}."
    ))

    buttons.push(TransformationBucketDeleteButton(
      bucket: @props.bucket
      isPending: @props.pendingActions.get('delete', false)
      enabled: @props.bucket.get('transformationsCount') == 0
      key: 'delete'
    ))

    buttons

  render: ->
    Link {className: 'tr', to: 'transformationBucket', params: {bucketId: @props.bucket.get('id')}},
      span {className: 'td'},
        h4 {}, @props.bucket.get('name')
      span {className: 'td'},
        small {}, @props.description || em {}, 'No description'
      span {className: 'td'},
        @buttons()
)

module.exports = TransformationBucketRow
