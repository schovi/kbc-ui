React = require 'react'

NewTransformationBucketModal = React.createFactory(require '../modals/NewTransformationBucket')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)

{button, span} = React.DOM

NewTransformationBucketButton = React.createClass
  displayName: 'NewTransformationBucketButton'

  render: ->
    ModalTrigger modal: NewTransformationBucketModal(),
      button className: 'btn btn-success',
        span className: 'kbc-icon-plus'
        'Add Bucket'

module.exports = NewTransformationBucketButton
