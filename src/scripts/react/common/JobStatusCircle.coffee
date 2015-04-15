React = require 'react'
ApplicationStore = require '../../stores/ApplicationStore'

images =
  green: require 'kbc-bootstrap/img/status-green.svg'
  grey: require 'kbc-bootstrap/img/status-grey.svg'
  orange: require 'kbc-bootstrap/img/status-orange.svg'
  red: require 'kbc-bootstrap/img/status-red.svg'

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
    ApplicationStore.getScriptsBasePath() + images[color]

module.exports = JobStatusCircle
