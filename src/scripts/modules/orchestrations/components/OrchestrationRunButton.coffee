React = require 'react'
OrchestrationActionCreators = require '../ActionCreators.coffee'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)

{button, span, i} = React.DOM

###
  Enabled/Disabled orchestration button with tooltip
###
OrchestrationRunButton = React.createClass
  displayName: 'OrchestrationRunButton'
  propTypes:
    orchestration: React.PropTypes.object.isRequired

  render: ->
    OverlayTrigger
      overlay: Tooltip null, 'Run'
      key: 'run'
      placement: 'top'
    ,
      button className: 'btn btn-link',
        i className: 'fa fa-fw fa-play'


module.exports = OrchestrationRunButton
