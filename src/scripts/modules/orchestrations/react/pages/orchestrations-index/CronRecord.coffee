React = require 'React'
prettyCron = require 'prettycron'

{span} = React.DOM

Cron = React.createFactory React.createClass(
  displayName: 'Cron'
  propTypes:
    crontabRecord: React.PropTypes.string

  shouldComponentUpdate: (nextProps) ->
    nextProps.crontabRecord != @props.crontabRecord

  cronUTCtext: (crontab) ->
    if !crontab
      return ""
    cArray = crontab.split(" ")
    if cArray and cArray[1] != "*"
      return " (UTC) "
    return ""

  render: ->
    span null,
      span null, prettyCron.toString(@props.crontabRecord),
        span null, @cronUTCtext(@props.crontabRecord)
)

module.exports = Cron