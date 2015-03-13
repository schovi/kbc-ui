React = require 'react'
prettyCron = require 'prettycron'

{span} = React.DOM

Cron = React.createClass(
  displayName: 'Cron'
  propTypes:
    crontabRecord: React.PropTypes.string

  shouldComponentUpdate: (nextProps) ->
    nextProps.crontabRecord != @props.crontabRecord

  cronUTCtext: (crontab) ->
    cArray = crontab.split(" ")
    if cArray and cArray[1] != "*"
      return " (UTC) "
    return ""

  render: ->
    span null,
      if @props.crontabRecord
        span null, prettyCron.toString(@props.crontabRecord),
          span null, @cronUTCtext(@props.crontabRecord)
      else
        'No Schedule'
)

module.exports = Cron
