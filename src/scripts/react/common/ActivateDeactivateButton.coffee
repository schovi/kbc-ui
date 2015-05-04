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
    mode: React.PropTypes.oneOf ['button', 'link']

  getDefaultProps: ->
    isPending: false
    mode: 'button'

  render: ->
    if @props.isPending
      React.DOM.span className: 'btn btn-link',
        React.createElement Loader, className: 'fa-fw'
    else
      tooltip = if @props.isActive then @props.deactivateTooltip else @props.activateTooltip

      React.createElement OverlayTrigger,
        overlay: React.createElement(Tooltip, null, tooltip)
        placement: 'top'
      ,
        if @props.mode == 'button'
          @_renderButton()
        else
          @_renderLink()

  _renderIcon: ->
    React.createElement Check,
      isChecked: @props.isActive


  _renderButton: ->
    React.DOM.button
      className: 'btn btn-link'
      onClick: @_handleClick
    ,
      @_renderIcon()

  _renderLink: ->
    React.DOM.a
      onClick: @_handleClick
    ,
      @_renderIcon()
      ' ' + if @props.isActive then @props.deactivateTooltip else @props.activateTooltip

  _handleClick: (e) ->
    @props.onChange !@props.isActive
    e.stopPropagation()
    e.preventDefault()
