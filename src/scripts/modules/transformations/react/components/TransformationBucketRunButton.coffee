React = require 'react'
OrchestrationActionCreators = require '../../../orchestrations/ActionCreators'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)

{button, span, i} = React.DOM

###
  Enabled/Disabled orchestration button with tooltip
###
TransformationRunButton = React.createClass
  displayName: 'TransformationRunButton'
  propTypes:
    bucket: React.PropTypes.object.isRequired

  render: ->
    button
      className: 'btn btn-link'
    ,
      i className: 'fa fa-fw fa-play'


module.exports = TransformationRunButton
