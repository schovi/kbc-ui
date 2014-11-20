React = require 'react'
DurationWithIcon = React.createFactory(require '../common/DurationWithIcon.coffee')
FinishedWithIcon = React.createFactory(require '../common/FinishedWithIcon.coffee')
JobStatusCircle = React.createFactory(require '../common/JobStatusCircle.coffee')
Link = React.createFactory(require('react-router').Link)

prettyCron = require 'prettycron'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)

{span, div, a, button, i} = React.DOM

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



OrchestrationRow = React.createClass(
  displayName: 'OrchestrationRow'
  propTypes:
    orchestration: React.PropTypes.object

  deleteOrchestration: (event) ->
    # todo
    false

  setOrchestrationActiveState: ->
    #todo

  runOrchestration: ->
    #todo


  buttons: ->
    buttons = []

    # TODO: button component
    buttons.push(OverlayTrigger
      overlay: Tooltip null, 'Delete orchestration'
      key: 'delete'
      placement: 'top'
    ,
      button className: 'btn btn-link',
        i className: 'fa fa-trash-o'
    )


    activateTooltip = if @props.orchestration.get('active') then 'Disable orchestration' else 'Enable orchestration'
    buttons.push(OverlayTrigger
      overlay: Tooltip null, activateTooltip
      key: 'activate'
      placement: 'top'
    ,
      button className: 'btn btn-link',
        i className: if @props.orchestration.get('active') then 'fa fa-check' else 'fa fa-times'
    )

    buttons.push(OverlayTrigger
      overlay: Tooltip null, 'Run'
      key: 'run'
      placement: 'top'
    ,
      button className: 'btn btn-link',
        i className: 'fa fa-play'
    )

    buttons


  cron: ->
    if @props.orchestration.get('crontabRecord')
      (span {className: 'inline-edit crontab-record'},
        (Cron {crontabRecord: @props.orchestration.get('crontabRecord')})
      )
    else
      (span {className: 'param-value pull-left'}, 'No schedule')


  render: ->

    lastExecutedJob = @props.orchestration.get('lastExecutedJob')
    if lastExecutedJob && lastExecutedJob.get 'startTime'
      duration = (DurationWithIcon {startTime: lastExecutedJob.get('startTime'), endTime: lastExecutedJob.get('endTime')})
    else
      duration = 'No run yet'

    (Link {className: "tr", to: 'orchestration', params: {id: @props.orchestration.get('id')}},
      (span {className: 'td'},
        (JobStatusCircle {status: lastExecutedJob?.get('status')})
        ' '
        @props.orchestration.get('name')
      ),
      (span {className: 'td'},
        (FinishedWithIcon endTime: lastExecutedJob?.get('endTime')) if lastExecutedJob?.get('endTime')
      ),
      (span {className: 'td'},
        duration
      ),
      (span {className: 'td'},
        @cron()
      ),
      (span {className: 'td text-right'},
        @buttons()
      )
    )
)

module.exports = OrchestrationRow