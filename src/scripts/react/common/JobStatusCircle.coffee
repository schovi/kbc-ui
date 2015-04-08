React = require 'react'
ApplicationStore = require '../../stores/ApplicationStore'

statusColorMap =
  success: 'green'
  error: 'red'
  warn: 'red'
  processing: 'orange'
  cancelled: 'grey'
  waiting: 'grey'
  terminating: 'grey'
  terminated: 'grey'

JobStatusCircle = React.createClass
  displayName: 'JobStatusCircle'
  propTypes:
    status: React.PropTypes.string

  render: ->
    color = statusColorMap[@props.status] || 'grey'

    React.DOM.img
      src: @_getPathForColor color

  _getPathForColor: (color) ->
    ApplicationStore.getScriptsBasePath() + "images/status-#{color}.svg"

module.exports = JobStatusCircle
