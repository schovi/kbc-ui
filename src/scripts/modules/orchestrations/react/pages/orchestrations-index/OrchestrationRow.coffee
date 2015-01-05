React = require 'react'
DurationWithIcon = React.createFactory(require '../../../../../react/common/DurationWithIcon.coffee')
FinishedWithIcon = React.createFactory(require '../../../../../react/common/FinishedWithIcon.coffee')
JobStatusCircle = React.createFactory(require '../../../../../react/common/JobStatusCircle.coffee')
Link = React.createFactory(require('react-router').Link)
OrchestrationActiveButton = React.createFactory(require '../../components/OrchestrationActiveButton.coffee')
OrchestrationDeleteButton = React.createFactory(require '../../components/OrchestrationDeleteButton.coffee')
OrchestrationRunButton = React.createFactory(require '../../components/OrchestrationRunButton.coffee')
CronRecord = React.createFactory(require './../../components/CronRecord.coffee')
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin.coffee'

OrchestrationActionCreators = require '../../../ActionCreators.coffee'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)

{span, div, a, button, i} = React.DOM


OrchestrationRow = React.createClass(
  displayName: 'OrchestrationRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    orchestration: React.PropTypes.object

  buttons: ->
    buttons = []

    buttons.push(OrchestrationDeleteButton(
      orchestration: @props.orchestration
      key: 'delete'
    ))

    buttons.push(OrchestrationActiveButton(
      orchestration: @props.orchestration
      key: 'activate'
    ))

    buttons.push(OrchestrationRunButton(
      orchestration: @props.orchestration
      key: 'run'
    ))

    buttons

  cron: ->
    if @props.orchestration.get('crontabRecord')
      (span {className: 'inline-edit crontab-record'},
        (CronRecord {crontabRecord: @props.orchestration.get('crontabRecord')})
      )
    else
      (span {className: 'param-value pull-left'}, 'No schedule')


  render: ->
    lastExecutedJob = @props.orchestration.get('lastExecutedJob')
    if lastExecutedJob && lastExecutedJob.get 'startTime'
      duration = (DurationWithIcon
        startTime: lastExecutedJob.get('startTime')
        endTime: lastExecutedJob.get('endTime')
        )
    else
      duration = 'No run yet'

    (Link {className: "tr", to: 'orchestration', params: {orchestrationId: @props.orchestration.get('id')}},
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
