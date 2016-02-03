React = require 'react'
{List} = require 'immutable'
TasksEditTableRow = React.createFactory(require './TasksEditTableRow')
PhaseEditRow = React.createFactory(require('./PhaseEditRow').default)

{div, strong, table, thead, tbody, th, td, tr} = React.DOM


TasksEditTable = React.createClass
  displayName: 'TasksEditTable'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired
    disabled: React.PropTypes.bool.isRequired
    onTaskDelete: React.PropTypes.func.isRequired
    onTaskUpdate: React.PropTypes.func.isRequired
    onTaskMove: React.PropTypes.func.isRequired
    isParallelismEnabled: React.PropTypes.bool.isRequired
    updateLocalState: React.PropTypes.func.isRequired
    localState: React.PropTypes.object.isRequired

  render: ->
    table className: 'table table-stripped kbc-table-layout-fixed',
      thead null,
        tr null,
          th style: {width: '3%'},
          th style: {width: '24%'}, 'Component'
          th style: null, 'Configuration'
          th style: {width: '8%'}, 'Action'
          th style: {width: '25%'}, 'Parameters'
          if @props.isParallelismEnabled
            th style: {width: '8%'}, 'Phase'
          th style: {width: '8%'}, 'Active'
          th style: {width: '10%'}, 'Continue on Failure'
          th style: {width: '5%'}
      tbody null,
        if @props.tasks.count()
          @renderPhasedTasksRows()
        else
          tr null,
            td
              className: 'text-muted'
              colSpan: 8
            ,
              'There are no tasks assigned yet. Please start by adding first task.'

  renderPhasedTasksRows: ->
    result = List()
    @props.tasks.map((phase) =>
      tasksRows = phase.get('tasks').map((task) =>
        TasksEditTableRow
          task: task
          component: @props.components.get(task.get('component'))
          disabled: @props.disabled
          key: task.get('id')
          onTaskDelete: @props.onTaskDelete
          onTaskUpdate: @props.onTaskUpdate
          onTaskMove: @props.onTaskMove
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
      td colSpan: '8',
        div className: 'text-center',
          strong null, phaseId

  isPhaseHidden: (phase) ->
    @props.localState.getIn [phase.get('id'), 'isHidden'], false

module.exports = TasksEditTable
