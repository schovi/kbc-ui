React = require 'react'

Loader = require './Loader'
Check = require './Check'

{Tooltip, OverlayTrigger} = require('react-bootstrap')

module.exports = React.createClass
  displayName: 'ActivateDeactivateButton'
  propTypes:
    activateTooltip: React.PropTypes.string.isRequired
    deactivateTooltip: React.PropTypes.string.isRequired
    isActive: React.PropTypes.bool.isRequired
    isPending: React.PropTypes.bool
    onChange: React.PropTypes.func.isRequired

  getDefaultProps: ->
    isPending: false

  render: ->
    if @props.isPending
      React.DOM.span className: 'btn btn-link',
        React.createElement Loader
    else
      tooltip = if @props.isActive then @props.deactivateTooltip else @props.activateTooltip

      React.createElement OverlayTrigger,
        overlay: React.createElement(Tooltip, null, tooltip)
        placement: 'top'
      ,
        React.DOM.button
          className: 'btn btn-link'
          onClick: @_handleClick
        ,
          React.createElement Check,
            isChecked: @props.isActive

  _handleClick: (e) ->
    console.log 'click', @props.isActive
    @props.onChange !@props.isActive
    e.stopPropagation()
    e.preventDefault()