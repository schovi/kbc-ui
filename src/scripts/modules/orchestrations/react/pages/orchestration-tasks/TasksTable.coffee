React = require 'react'
{List, Map} = require 'immutable'
TasksTableRow = React.createFactory(require './TasksTableRow')
PhaseRow = React.createFactory(require('./PhaseRow').default)


{div, strong, table, thead, tbody, th, td, tr} = React.DOM


TasksTable = React.createClass
  displayName: 'TasksTable'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    orchestration: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired
    onRun: React.PropTypes.func.isRequired
    updateLocalState: React.PropTypes.func.isRequired
    localState: React.PropTypes.object.isRequired

  _handleTaskRun: (task) ->
    @props.onRun(task)

  render: ->
    table className: 'table table-stripped kbc-table-layout-fixed',
      thead null,
        tr null,
          th null, 'Component'
          th null, 'Configuration'
          th style: {width: '10%'}, 'Action'
          th null, 'Parameters'
          th style: {width: '8%'}, 'Active'
          th style: {width: '12%'}, 'Continue on Failure'
          th style: {width: '8%'}, ''
      tbody null,
        if @props.tasks.count()
          @renderPhasedTasksRows()
        else
          tr null,
            td
              colSpan: 7
              className: 'text-muted'
            ,
              'There are no tasks assigned yet.'

  renderPhasedTasksRows: ->
    result = List()
    @props.tasks.map((phase) =>
      tasksRows = phase.get('tasks').map((task) =>
        TasksTableRow
          task: task
          orchestration: @props.orchestration
          component: @props.components.get(task.get('component'))
          key: task.get('id')
          onRun: @_handleTaskRun
      )
      phaseRow = @renderPhaseRow(phase)
      result = result.push(phaseRow)
      if not @isPhaseHidden(phase)
        result = result.concat(tasksRows)
    )
    return result.toArray()

  renderPhaseRow: (phase) ->
    phaseId = phase.get('id')
    isHidden = @isPhaseHidden(phase)
    tr
      onClick: =>
        @props.updateLocalState([phaseId, 'isHidden'], not isHidden)
    ,
      td colSpan: '7',
        div className: 'text-center',
          strong null, phaseId

  isPhaseHidden: (phase) ->
    @props.localState.getIn [phase.get('id'), 'isHidden'], false

module.exports = TasksTable
