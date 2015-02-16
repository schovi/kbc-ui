React = require 'react'

NewOrchestrationModal = React.createFactory(require '../modals/NewOrchestration')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)

{button, span} = React.DOM

NewOrchestrationButton = React.createClass
  displayName: 'NewOrchestrationButton'

  render: ->
    ModalTrigger modal: NewOrchestrationModal(),
      button className: 'btn btn-success',
        span className: 'kbc-icon-plus'
        'Add Orchestration'


module.exports = NewOrchestrationButton
