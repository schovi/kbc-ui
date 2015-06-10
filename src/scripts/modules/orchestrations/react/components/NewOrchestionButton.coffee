React = require 'react'

NewOrchestrationModal = React.createFactory(require '../modals/NewOrchestration')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)


{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'NewOrchestrationButton'
  propTypes:
    buttonLabel: React.PropTypes.string

  getDefaultProps: ->
    buttonLabel: 'Add Orchestration'

  render: ->
    ModalTrigger modal: NewOrchestrationModal(),
      button className: 'btn btn-success',
        span className: 'kbc-icon-plus'
        @props.buttonLabel
