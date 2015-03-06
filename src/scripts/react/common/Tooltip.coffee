React = require 'react'

{OverlayTrigger, Tooltip} = require 'react-bootstrap'

module.exports = React.createClass
  dispayName: 'Tooltip'
  propTypes:
    tooltip: React.PropTypes.string.isRequired

  render: ->
    tooltip = React.createElement Tooltip, null,
      @props.tooltip

    React.createElement OverlayTrigger,
      overlay: tooltip
    ,
      React.DOM.span null, @props.children
