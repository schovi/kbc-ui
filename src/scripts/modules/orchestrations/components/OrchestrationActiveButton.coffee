React = require 'react'
OrchestrationActionCreators = require '../ActionCreators.coffee'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)

{button, span, i} = React.DOM

###
  Enabled/Disabled orchestration button with tooltip
###
OrchestrationActiveButton = React.createClass
  displayName: 'OrchestrationActiveButton'
  propTypes:
    orchestration: React.PropTypes.object.isRequired

  render: ->
    isActive = @props.orchestration.get('active')
    activateTooltip = if isActive then 'Disable orchestration' else 'Enable orchestration'
    OverlayTrigger
      overlay: Tooltip null, activateTooltip
      placement: 'top'
    ,
      button
        className: 'btn btn-link'
        onClick: if isActive then @_setOrchestrationDisabled else @_setOrchestrationActive
      ,
        i className: if isActive then 'fa fa-fw fa-check' else 'fa fa-fw fa-times'


  _setOrchestrationActive: (e) ->
    OrchestrationActionCreators.activateOrchestration(@props.orchestration.get('id'))
    e.stopPropagation()
    e.preventDefault()

  _setOrchestrationDisabled: (e) ->
    OrchestrationActionCreators.disableOrchestration(@props.orchestration.get('id'))
    e.stopPropagation()
    e.preventDefault()

module.exports = OrchestrationActiveButton
