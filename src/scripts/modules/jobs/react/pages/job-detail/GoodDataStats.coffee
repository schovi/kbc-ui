React = require 'react'

{div} = React.DOM

module.exports = React.createClass
  displayName: 'GoodDataResultStats'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    events: React.PropTypes.object.isRequired

  componentDidMount: ->
    @props.events.load().then (result) =>
      console.log "loaded", result
      console.log "EVENTS", @props.events.getEvents().toJS()

  render: ->
    div null, 'stats detail'
