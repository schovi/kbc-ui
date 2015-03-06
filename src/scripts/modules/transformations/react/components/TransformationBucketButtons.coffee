React = require 'react'

NewTransformationBucketModal = React.createFactory(require '../modals/NewTransformationBucket')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
Link = React.createFactory(require('react-router').Link)

{button, span} = React.DOM

TransformationBucketButtons = React.createClass
  displayName: 'NewTransformationBucketButton'

  render: ->
    span {},
      Link to: 'sandbox',
        button className: 'btn btn-link',
          span className: 'kbc-icon-cog'
          'Sandbox'
      ModalTrigger modal: NewTransformationBucketModal(),
        button className: 'btn btn-success',
          span className: 'kbc-icon-plus'
          'Add Bucket'


module.exports = TransformationBucketButtons
