React = require 'react'

NewTransformationBucketModal = React.createFactory(require '../modals/NewTransformationBucket')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
Link = React.createFactory(require('react-router').Link)

{button, span} = React.DOM

TransformationBucketButtons = React.createClass
  displayName: 'NewTransformationBucketButton'

  render: ->
    span {},
      ModalTrigger modal: NewTransformationBucketModal(),
        button className: 'btn btn-success',
          span className: 'kbc-icon-plus'
          'Add Bucket'
      Link to: 'sandbox',
        button className: 'btn btn-success',
          span className: 'kbc-icon-cog'
          'Sandbox'
    

module.exports = TransformationBucketButtons
