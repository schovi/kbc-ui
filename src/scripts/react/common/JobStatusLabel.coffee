React = require 'react'

JobStatusLabel = React.createClass(
  displayName: 'JobStatusLabel'
  propTypes:
    status: React.PropTypes.string
  render: ->
    classMap =
      success: 'label-success'
      error: 'label-danger'
      processing: 'label-warning'
      canceled: 'label-canceled'
      cancelled: 'label-canceled'
      waiting: 'label-default'
      warn: 'label-danger'

    className = classMap[@props.status]
    className += ' processing'  if @props.status == 'processing'

    React.DOM.span({className: "label #{className}"}, @props.status)
)

module.exports = JobStatusLabel