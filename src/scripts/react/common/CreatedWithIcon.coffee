React = require 'react'
moment = require 'moment'
{Tooltip} = require './common'

{span, i} = React.DOM

CreatedWithIcon = React.createClass
  displayName: 'CreatedWithIcon'
  propTypes:
    createdTime: React.PropTypes.string

  tooltip: ->
    React.createElement Tooltip {},
      @props.createdTime


  render: ->
    span {},
      React.createElement Tooltip,
        tooltip: @props.createdTime
      ,
        i {className: 'fa fa-calendar'}
      ' '
      moment(@props.createdTime).fromNow()

module.exports = CreatedWithIcon
