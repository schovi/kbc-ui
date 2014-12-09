React = require 'react'
OrchestrationActionCreators = require '../ActionCreators.coffee'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)

{button, span, i} = React.DOM

###
  Enabled/Disabled orchestration button with tooltip
###
OrchestrationDeleteButton = React.createClass
  displayName: 'OrchestrationActiveButton'
  propTypes:
    orchestration: React.PropTypes.object.isRequired

  render: ->
    OverlayTrigger
      overlay: Tooltip null, 'Delete orchestration'
      key: 'delete'
      placement: 'top'
    ,
      button className: 'btn btn-link',
        i className: 'kbc-icon-cup'

module.exports = OrchestrationDeleteButton
