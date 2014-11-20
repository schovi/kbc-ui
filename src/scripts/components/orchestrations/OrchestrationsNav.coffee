React = require 'react'
_ = require 'underscore'

OrchestrationStore = require '../../stores/OrchestrationStore.coffee'

DurationWithIcon = React.createFactory(require '../common/DurationWithIcon.coffee')
FinishedWithIcon = React.createFactory(require '../common/FinishedWithIcon.coffee')
JobStatusCircle = React.createFactory(require '../common/JobStatusCircle.coffee')
Link = React.createFactory(require('react-router').Link)
ActiveState = require('react-router').ActiveState

{ a, span, div} = React.DOM

OrchestrationRow = React.createFactory React.createClass(
  displayName: 'OrchestrationRow'
  propTypes:
    orchestration: React.PropTypes.object
    isActive: React.PropTypes.bool
  mixins: [ ActiveState ]
  render: ->
    isActive = @isActive('orchestration', id: @props.orchestration.get('id'))
    className = if isActive then 'active' else ''

    if  !@props.orchestration.get('active')
      disabled = (span {className: 'pull-right kb-disabled'}, 'Disabled')
    else
      disabled = ''

    lastExecutedJob = @props.orchestration.get 'lastExecutedJob'
    if lastExecutedJob?.get('startTime')
      duration = (DurationWithIcon {startTime: lastExecutedJob.get('startTime'), endTime: lastExecutedJob.get('endTime')})
    else
      duration = ''

    (Link {className: "list-group-item #{className}", to: 'orchestration', params: {id: @props.orchestration.get('id')} },
      (JobStatusCircle {status: lastExecutedJob?.get('status')}),
      (span null, @props.orchestration.get('name')),
      disabled,
      (span {className: 'kb-info clearfix'},
        duration,
        (span {className: 'pull-right'},
          (FinishedWithIcon endTime: lastExecutedJob.get('endTime')) if lastExecutedJob?.get('endTime')
        )
      )
    )
)

getStateFromStores = ->
  orchestrations: OrchestrationStore.getAll()

OrchestrationsNav = React.createClass(
  displayName: 'OrchestrationsNavList'
  propTypes:
    orchestrations: React.PropTypes.array
    filter: React.PropTypes.string
  getInitialState: ->
    getStateFromStores()
  render: ->
    filtered = @state.orchestrations
    if filtered.size
      childs = filtered.map((orchestration) ->
        OrchestrationRow {orchestration: orchestration, key: orchestration.get('id')}
      , @).toArray()
    else
      childs = (div className: 'list-group-item',
        'No Orchestrations found'
      )

    (div className: 'list-group kb-orchestrations-nav',
      childs
    )
)

module.exports = OrchestrationsNav