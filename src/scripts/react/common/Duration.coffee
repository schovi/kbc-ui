React = require 'react'
timeInWords = require '../../utils/duration'

# origin: https://github.com/travis-ci/travis-web/blob
#                /aa06f3947eaeeedf594a59f0ce629ad4cd2763c6/assets/scripts
#                /app/helpers/helpers
durationFrom = (started, finished) ->
  (new Date(finished).getTime() - new Date(started).getTime()) / 1000


StaticDuration = React.createClass(
  displayName: 'StaticDuration'
  propTypes:
    startTime: React.PropTypes.string
    endTime: React.PropTypes.string
  durationFormatted: ->
    timeInWords(durationFrom(@props.startTime, @props.endTime), true)
  render: ->
    (React.DOM.span {}, @durationFormatted())
)

DynamicDuration = React.createClass(
  displayName: 'Duration'
  propTypes:
    startTime: React.PropTypes.string
  getInitialState: ->
    endTime: new Date().toString()
  componentDidMount: ->
    @interval = setInterval(@tick, 1000)
  componentWillUnmount: ->
    clearInterval(@interval)
  tick: ->
    @setState
      endTime: new Date().toString()
  durationFormatted: ->
    timeInWords(durationFrom(@props.startTime, @state.endTime))
  render: ->
    (React.DOM.span {}, @durationFormatted())
)

Duration = React.createClass(
  displayName: 'Duration'
  propTypes:
    startTime: React.PropTypes.string
    endTime: React.PropTypes.string
  render: ->
    if !@props.startTime
      return (React.DOM.span {}, '')

    if !@props.endTime
      return React.createElement(DynamicDuration, startTime: @props.startTime)

    return React.createElement(StaticDuration, startTime: @props.startTime, endTime: @props.endTime)
)

module.exports = Duration
