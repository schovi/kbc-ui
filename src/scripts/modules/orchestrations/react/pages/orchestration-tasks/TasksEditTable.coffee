React = require 'react'
{List} = require 'immutable'
TasksEditTableRow = React.createFactory(require './TasksEditTableRow')
PhaseEditRow = React.createFactory(require('./PhaseEditRow').default)

dnd = require 'react-dnd'

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
    handlePhaseMove: React.PropTypes.func.isRequired

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
          isDraggingPhase: @props.localState.getIn [phase.get('id'), 'isDragging']
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
    return PhaseEditRow
      onPhaseMove: @onPhaseMove
      phase: phase
      toggleHide: =>
        @props.updateLocalState([phaseId, 'isHidden'], not isHidden)
      onBeginDrag: (phaseId) ->
        @props.updateLocalState([phaseId, 'isDragging'], true)
      onEndDrag: (phaseId) ->
        @props.updateLocalState([phaseId, 'isDragging'], false)

  isPhaseHidden: (phase) ->
    @props.localState.getIn [phase.get('id'), 'isHidden'], false

  onPhaseMove: (afterPhaseId, phaseId) ->
    console.log('MOVE', afterPhaseId, phaseId)
    @props.handlePhaseMove(phaseId, afterPhaseId)

module.exports = TasksEditTable
