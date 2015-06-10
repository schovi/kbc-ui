
React = require 'react'

NewTransformationBucketModal = React.createFactory(require '../modals/NewTransformationBucket')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'NewTransformationBucketButton'
  propTypes:
    buttonLabel: React.PropTypes.string

  getDefaultProps: ->
    buttonLabel: 'Add Bucket'

  render: ->
    ModalTrigger modal: NewTransformationBucketModal(),
      button className: 'btn btn-success',
        span className: 'kbc-icon-plus'
        @props.buttonLabel
