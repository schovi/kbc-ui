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
    isActive = @isActive('orchestration', id: @props.orchestration.id)
    className = if isActive then 'active' else ''

    if  !@props.orchestration.active
      disabled = (span {className: 'pull-right kb-disabled'}, 'Disabled')
    else
      disabled = ''

    if @props.orchestration.lastExecutedJob?.startTime
      duration = (DurationWithIcon {startTime: @props.orchestration.lastExecutedJob?.startTime, endTime: @props.orchestration.lastExecutedJob?.endTime})
    else
      duration = ''

    (Link {className: "list-group-item #{className}", to: 'orchestration', params: {id: @props.orchestration.id} },
      (JobStatusCircle {status: @props.orchestration.lastExecutedJob?.status}),
      (span null, @props.orchestration.name),
      disabled,
      (span {className: 'kb-info clearfix'},
        duration,
        (span {className: 'pull-right'},
          (FinishedWithIcon endTime: @props.orchestration.lastExecutedJob?.endTime) if @props.orchestration.lastExecutedJob?.endTime
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
    if filtered.length
      childs = _.map(filtered, (orchestration) ->
        OrchestrationRow {orchestration: orchestration, key: orchestration.id}
      , @)

    else
      childs = (div className: 'list-group-item',
        'No Orchestrations found'
      )

    (div className: 'list-group kb-orchestrations-nav',
      childs
    )
)

module.exports = OrchestrationsNav