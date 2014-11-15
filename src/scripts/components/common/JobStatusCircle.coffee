React = require 'react'

JobStatusCircle = React.createClass
  displayName: 'JobStatusCircle'
  propTypes:
    status: React.PropTypes.string

  render: ->
    classMap =
      success: 'status-success'
      error: 'status-error'
      waiting: 'status-waiting'
      canceled: 'status-canceled'
      warn: 'status-error'
      processing: 'status-warn'

    className = classMap[@props.status]
    React.DOM.span {className: "fa fa-circle kb-orchestration-status #{className}"}


module.exports = JobStatusCircle