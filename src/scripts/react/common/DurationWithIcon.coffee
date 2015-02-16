React = require 'react'
Duration = React.createFactory(require './Duration')

{span, i} = React.DOM

DurationWithIcon = React.createClass
  displayName: 'DurationWithIcon'
  propTypes:
    startTime: React.PropTypes.string
    endTime: React.PropTypes.string
  render: ->
    span {},
      i {className: 'fa fa-clock-o'}
      ' '
      Duration {startTime: @props.startTime, endTime: @props.endTime}


module.exports = DurationWithIcon
