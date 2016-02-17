React = require 'react'
{List, Map} = require 'immutable'
TasksTableRow = React.createFactory(require './TasksTableRow')
PhaseRow = React.createFactory(require('./PhaseRow').default)


{div, span, table, thead, tbody, th, td, tr} = React.DOM


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
          th style: {width: '12%'}, 'Action'
          th style: {width: '8%'}, 'Active'
          th style: {width: '8%'}, 'Continue on Failure'
          th style: {width: '10%'}
      tbody null,
        if @props.tasks.count()
          @renderPhasedTasksRows()
        else
          tr null,
            td
              colSpan: '6'
              className: 'text-muted'
            ,
              'There are no tasks assigned yet.'

  renderPhasedTasksRows: ->
    result = List()
    idx = 0
    @props.tasks.map((phase) =>
      idx++
      color = if idx % 2 > 0 then '#fff' else '#f9f9f9' #'rgb(227, 248, 255)'
      tasksRows = phase.get('tasks').map((task) =>
        TasksTableRow
          color: color
          task: task
          orchestration: @props.orchestration
          component: @props.components.get(task.get('component'))
          key: task.get('id')
          onRun: @_handleTaskRun
      )
      phaseRow = @renderPhaseRow(phase, color)
      result = result.push(phaseRow)
      if not @isPhaseHidden(phase)
        result = result.concat(tasksRows)
    )
    return result.toArray()

  renderPhaseRow: (phase, color) ->
    phaseId = phase.get('id')
    isHidden = @isPhaseHidden(phase)
    PhaseRow
      color: color
      key: phaseId
      phase: phase
      toggleHide: =>
        @props.updateLocalState(['phases', phaseId, 'isHidden'], not isHidden)

  isPhaseHidden: (phase) ->
    @props.localState.getIn ['phases', phase.get('id'), 'isHidden'], false

module.exports = TasksTable
