React = require 'react'
TransformationActionCreators = require '../../ActionCreators'

Router = require 'react-router'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Confirm = React.createFactory(require '../../../../react/common/Confirm')
Loader = React.createFactory(require '../../../../react/common/Loader')

{button, span, i} = React.DOM

###
  Enabled/Disabled transformation delete button with tooltip
###
TransformationBucketDeleteButton = React.createClass
  displayName: 'TransformationBucketDeleteButton'
  mixins: [Router.Navigation]
  propTypes:
    bucket: React.PropTypes.object.isRequired
    isPending: React.PropTypes.bool.isRequired
    enabled: React.PropTypes.bool.isRequired

  render: ->
    if !@props.enabled
      button
        className: 'btn btn-link disabled'
        title: "Cannot be deleted, contains transformations"
        # TODO disable default Link action!
      ,
        i className: 'kbc-icon-cup'
    else if @props.isPending
      span className: 'btn btn-link',
        Loader()
    else
      OverlayTrigger
        overlay: Tooltip null, 'Delete transformation bucket'
        key: 'delete'
        placement: 'top'
      ,
        Confirm
          title: 'Delete Transformation Bucket'
          text: "Do you really want to delete transformation bucket #{@props.bucket.get('name')}"
          buttonLabel: 'Delete'
          onConfirm: @_deleteTransformationBucket
        ,
          button className: 'btn btn-link',
            i className: 'kbc-icon-cup'

  _deleteTransformationBucket: ->
    @transitionTo 'transformations'
    # if transformation is deleted immediately view is rendered with missing bucket because of store changed
    bucketId = @props.bucket.get('id')
    setTimeout ->
      TransformationActionCreators.deleteTransformationBucket(bucketId)

module.exports = TransformationBucketDeleteButton
