React = require 'react'
moment = require 'moment'
Tooltip = React.createFactory(require('./common').Tooltip)

{span, i} = React.DOM

FinishedWithIcon = React.createClass
  displayName: 'FinishedWithIcon'
  propTypes:
    endTime: React.PropTypes.string
    tooltipPlacement: React.PropTypes.string
  getDefaultProps: ->
    tooltipPlacement: 'right'
  render: ->
    span {},
      Tooltip
        tooltip: @props.endTime
        placement: @props.tooltipPlacement
      ,
        i {className: 'fa fa-calendar'}
      ' '
      moment(@props.endTime).fromNow()


module.exports = FinishedWithIcon
