React = require 'react'

statusColorMap =
  success: 'green'
  error: 'red'
  warn: 'red'
  processing: 'orange'
  cancelled: 'grey'
  waiting: 'grey'

JobStatusCircle = React.createClass
  displayName: 'JobStatusCircle'
  propTypes:
    status: React.PropTypes.string

  render: ->
    color = statusColorMap[@props.status] || 'grey'

    React.DOM.img
      src: @_getPathForColor color

  _getPathForColor: (color) ->
    "images/status-#{color}.svg"

module.exports = JobStatusCircle