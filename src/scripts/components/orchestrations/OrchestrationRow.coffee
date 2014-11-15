React = require 'react'
DurationWithIcon = React.createFactory(require '../common/DurationWithIcon.coffee')
FinishedWithIcon = React.createFactory(require '../common/FinishedWithIcon.coffee')
JobStatusCircle = React.createFactory(require '../common/JobStatusCircle.coffee')
Link = React.createFactory(require('react-router').Link)

{span, div, a} = React.DOM

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
    (span null, 'todo')
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

    buttons.push(Tooltip({tooltip: 'Delete orchestration', key: 'delete'}, button {className: 'btn btn-default btn-sm', ref: 'deleteButton', onClick: @deleteOrchestration},
      (i {className: 'fa fa-trash-o'})
    ))

    activateTooltip = if @props.orchestration.active then 'Disable orchestration' else 'Enable orchestration'
    buttons.push(Tooltip({tooltip: activateTooltip, key: 'activate'}, button {className: 'btn btn-default btn-sm', ref: 'activateButton', onClick: @setOrchestrationActiveState},
      (i {className: if @props.orchestration.active then 'fa fa-check' else 'fa fa-times'})
    ))

    buttons.push(Tooltip({tooltip: 'Run', key: 'run'}, button {className: 'btn btn-default btn-sm', ref: 'runButton', onClick: @runOrchestration},
      (i {className: 'fa fa-play'})
    ))

    buttons


  cron: ->
    if @props.orchestration.crontabRecord
      (span {className: 'inline-edit crontab-record'},
        (Cron {crontabRecord: @props.orchestration.crontabRecord})
      )
    else
      (span {className: 'param-value pull-left'}, 'No schedule')


  render: ->

    if @props.orchestration.lastExecutedJob?.startTime
      duration = (DurationWithIcon {startTime: @props.orchestration.lastExecutedJob?.startTime, endTime: @props.orchestration.lastExecutedJob?.endTime})
    else
      duration = 'No run yet'

    (Link {className: "list-group-item", to: 'orchestration', params: {id: @props.orchestration.id}},
      (span {className: 'row'},
        (span {className: 'col-md-4 kb-name-col'},
          (JobStatusCircle {status: @props.orchestration.lastExecutedJob?.status}),
          @props.orchestration.name
        ),
        (span {className: 'col-md-2 kb-info'},
          (FinishedWithIcon endTime: @props.orchestration.lastExecutedJob?.endTime) if @props.orchestration.lastExecutedJob?.endTime
        ),
        (span {className: 'kb-info col-md-2'},
          duration
        ),
        (span {className: 'kb-info col-md-2'},
          @cron()
        ),
        (span {className: 'col-md-2'},
          (span {className: 'pull-right kb-actions'}
            # todo buttons
          )
        )
      )
    )
)

module.exports = OrchestrationRow