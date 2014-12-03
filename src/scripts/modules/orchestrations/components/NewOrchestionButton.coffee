React = require 'react'

{button, span} = React.DOM

NewOrchestrationButton = React.createClass
  displayName: 'NewOrchestrationButton'

  render: ->
    button className: 'btn btn-success',
      span className: 'kbc-icon-plus'
      'Add Orchestration'


module.exports = NewOrchestrationButton
