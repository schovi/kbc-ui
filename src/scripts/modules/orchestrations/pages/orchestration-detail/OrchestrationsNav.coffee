React = require 'react'

OrchestrationStore = require '../../stores/OrchestrationsStore.coffee'
OrchestrationsActionCreators = require '../../actionCreators.coffee'

DurationWithIcon = React.createFactory(require '../../../../components/common/DurationWithIcon.coffee')
FinishedWithIcon = React.createFactory(require '../../../../components/common/FinishedWithIcon.coffee')
JobStatusCircle = React.createFactory(require '../../../../components/common/JobStatusCircle.coffee')
Link = React.createFactory(require('react-router').Link)
State = require('react-router').State

{ a, span, div, strong, em} = React.DOM

OrchestrationRow = React.createFactory React.createClass(
  displayName: 'OrchestrationRow'
  propTypes:
    orchestration: React.PropTypes.object
  mixins: [ State ]
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

    (Link {className: "list-group-item tr #{className}", to: 'orchestration', params: {orchestrationId: @props.orchestration.get('id')} },
      (span {className: 'td'},
        (JobStatusCircle {status: lastExecutedJob?.get('status')})
      ),
      (span {className: 'td'},
        (strong null, @props.orchestration.get('name')),
        duration
      ),
      (span {className: 'td'},
        (em null,
          disabled
        ),
        (span {className: 'kb-info clearfix'},
          (FinishedWithIcon endTime: lastExecutedJob.get('endTime')) if lastExecutedJob?.get('endTime')
        )
      )
    )
)

getStateFromStores = ->
  orchestrations: OrchestrationStore.getFiltered()

OrchestrationsNav = React.createClass(
  displayName: 'OrchestrationsNavList'

  getInitialState: ->
    getStateFromStores()

  componentDidMount: ->
    OrchestrationStore.addChangeListener(@_onChange)
    OrchestrationsActionCreators.loadOrchestrations()

  componentWillUnmount: ->
    OrchestrationStore.removeChangeListener(@_onChange)

  _onChange: ->
    @setState(getStateFromStores())

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

    (div className: 'list-group kb-orchestrations-nav table',
      childs
    )
)

module.exports = OrchestrationsNav