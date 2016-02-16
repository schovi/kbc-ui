React = require 'react'
{Map, List} = require 'immutable'
TasksEditTableRow = React.createFactory(require './TasksEditTableRow')
PhaseEditRow = React.createFactory(require('./PhaseEditRow').default)
PhaseModal = require('../../modals/Phase').default
MergePhasesModal = require('../../modals/MergePhasesModal').default
MoveTasksModal = require('../.././modals/MoveTasksModal').default
Tooltip = React.createFactory(require('../../../../../react/common/Tooltip').default)
{small, a, ul, li, i, div, span, strong, table, button, thead, tbody, th, td, tr} = React.DOM
AddTaskModal = require('../../modals/add-task/AddTaskModal')
EmptyState = require('../../../../components/react/components/ComponentEmptyState').default
DropdownButton = React.createFactory(require('react-bootstrap').DropdownButton)


TasksEditTable = React.createClass
  displayName: 'TasksEditTable'

  propTypes:
    tasks: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired
    disabled: React.PropTypes.bool.isRequired
    onTaskDelete: React.PropTypes.func.isRequired
    onTaskUpdate: React.PropTypes.func.isRequired
    updateLocalState: React.PropTypes.func.isRequired
    localState: React.PropTypes.object.isRequired
    handlePhaseMove: React.PropTypes.func.isRequired
    handlePhaseUpdate: React.PropTypes.func.isRequired
    handlePhasesSet: React.PropTypes.func.isRequired
    handleAddTask: React.PropTypes.func.isRequired

  render: ->
    span null,
      @_renderPhaseModal()
      @_renderMergePhaseModal()
      @_renderMoveTasksModal()
      @_renderSingleMoveTaskModal()
      @_renderAddTaskModal()
      table className: 'table table-stripped kbc-table-layout-fixed',
        thead null,
          tr null,
            th style: {width: '12%'}, @renderHeaderActionButtons()
            th null, 'Component'
            th null, 'Configuration'
            th style: {width: '12%'}, 'Action'
            th style: {width: '8%'}, 'Active'
            th style: {width: '8%'}, 'Continue on Failure'
            th style: {width: '10%'},
        tbody null,
          if @props.tasks.count()
            @renderPhasedTasksRows()
          else
            tr null,
              td
                className: 'text-muted'
                colSpan: '7'
              ,
                'There are no tasks assigned yet. Please start by adding first task.'

  renderHeaderActionButtons: ->
    ul className: 'nav nav-stacked',
      DropdownButton
        bsSize: 'small'
        bsStyle: 'small'
        style: {padding: '0'}
        title: span null, 'Actions'
        navItem: true
      ,
        li className: (if @canMergePhases() then '' else 'disabled'),
          a
            onClick: if @canMergePhases() then @toggleMergePhases else ->
            small null,
              ' Merge selected phases'
        li className: (if @canMoveTasks() then '' else 'disabled'),
          a
            onClick: if @canMoveTasks() then @onToggleMoveTasks else ->
            small null,
              ' Move selected tasks between phases'
        li null,
          a
            onClick: @onToggleCollapsePhases
            small null, ' Collapse/Expand phases'

  onToggleCollapsePhases: ->
    phases = @props.localState.get('phases', Map())
    allHidden = false
    allHidden = phases.reduce((allHidden, p) ->
      return allHidden or p.get('isHidden', false)
    , allHidden)
    phases = @props.tasks.map((p) ->
      phaseId = p.get('id')
      return Map({phaseId: phaseId, isHidden: not allHidden})
      ).toMap().mapKeys((key, phase) ->
      phase.get('phaseId')
    )
    @props.updateLocalState('phases', phases)


    # ['phases', phase.get('id'), 'isHidden'], false


  renderPhasedTasksRows: ->
    result = List()
    @props.tasks.map((phase) =>
      tasksRows = phase.get('tasks').map((task) =>
        taskId = task.get('id')
        TasksEditTableRow
          task: task
          component: @props.components.get(task.get('component'))
          disabled: @props.disabled
          key: taskId
          onTaskDelete: @props.onTaskDelete
          onTaskUpdate: @props.onTaskUpdate
          isDraggingPhase: @props.localState.getIn ['phases', phase.get('id'), 'isDragging']
          isMarked: @props.localState.getIn(['moveTasks', 'marked', taskId], false)
          toggleMarkTask: =>
            @_toggleMarkTask(task)
          onMoveSingleTask: =>
            @_toggleMoveSingleTask(task, phase.get('id'))
      )
      phaseRow = @renderPhaseRow(phase)
      result = result.push(phaseRow)
      if not @isPhaseHidden(phase)
        if tasksRows.count() > 0
          result = result.concat(tasksRows)
        else
          result = result.concat(@_renderEmptyTasksRow(phase.get('id')))
    )
    return result.toArray()

  _renderEmptyTasksRow: (phaseId) ->
    tr null,
      td
        className: 'text-muted'
        colSpan: 7
      ,
        React.createElement EmptyState, null,
          "No tasks assigned to #{phaseId} yet. Empty phases will not be saved."
          div null,
            button
              className: 'btn btn-primary btn-sm'
              onClick: =>
                @props.updateLocalState(['newTask', 'phaseId'], phaseId)
            ,
              'Add task'

  _renderAddTaskModal: ->
    React.createElement AddTaskModal,
      onConfigurationSelect: @props.handleAddTask
      phaseId: @props.localState.getIn ['newTask', 'phaseId']
      show: !!@props.localState.getIn ['newTask', 'phaseId']
      onHide: =>
        @props.updateLocalState ['newTask'], Map()


  _toggleMoveSingleTask: (task, ignoredPhaseId) ->
    toggleMap = Map({
      ignorePhase: ignoredPhaseId
      show: true
      task: task })
    @props.updateLocalState(['moveSingleTask'], toggleMap)

  _renderSingleMoveTaskModal: ->
    React.createElement MoveTasksModal,
      title: 'Move task to phase'
      ignorePhaseId: @props.localState.getIn(['moveSingleTask', 'ignorePhase'], null)
      show: @props.localState.getIn(['moveSingleTask', 'show'], false)
      phases: @props.tasks.map((phase) -> phase.get('id'))
      onHide: =>
        @props.updateLocalState(['moveSingleTask', 'show'], false)
      onMoveTasks: (phaseId) =>
        task = @props.localState.getIn(['moveSingleTask', 'task'])
        tasks = Map().set(task.get('id'), task)
        @_moveTasks(phaseId, tasks)
        @props.updateLocalState('moveSingleTask', Map())


  _renderMoveTasksModal: ->
    React.createElement MoveTasksModal,
      show: @props.localState.getIn(['moveTasks', 'show'], false)
      phases: @props.tasks.map((phase) -> phase.get('id'))
      onHide: =>
        @props.updateLocalState(['moveTasks', 'show'], false)
      onMoveTasks: (phaseId) =>
        markedTasks = @props.localState.getIn(['moveTasks', 'marked'])
        @_moveTasks(phaseId, markedTasks)
        @props.updateLocalState('moveTasks', Map())

  onToggleMoveTasks: ->
    @props.updateLocalState(['moveTasks', 'show'], true)

  _moveTasks: (phaseId, markedTasks) ->
    found = true
    phase = @props.tasks.find((p) -> p.get('id') == phaseId)
    if not phase
      phase = Map({id: phaseId})
      found = false
    destinationTasks = phase.get('tasks', List())
    tasksToMerge = markedTasks.filter((mt) ->
      not destinationTasks.find((dt) -> dt.get('id') == mt.get('id'))
      ).toList()
    resultTasks = destinationTasks.concat(tasksToMerge)
    newPhase = phase.set('tasks', resultTasks)
    newPhases = @props.tasks.map (p) ->
      if p.get('id') == phaseId
        return newPhase
      tmpTasks = p.get('tasks').filter((t) -> not markedTasks.has(t.get('id')))
      return p.set('tasks', tmpTasks)

    if not found
      newPhases = newPhases.push(newPhase)
    @props.handlePhasesSet(newPhases)


  _toggleMarkTask: (task) ->
    path = ['moveTasks', 'marked', task.get('id')]
    #invert true/false task/null
    if @props.localState.getIn(path, null) != null
      task = null
    @props.updateLocalState(path, task)

  renderPhaseRow: (phase) ->
    phaseId = phase.get('id')
    isHidden = @isPhaseHidden(phase)
    return PhaseEditRow
      key: phaseId
      onPhaseMove: @onPhaseMove
      phase: phase
      toggleHide: =>
        @props.updateLocalState(['phases', phaseId, 'isHidden'], not isHidden)
      togglePhaseIdChange: @togglePhaseIdEdit
      isMarked: @props.localState.getIn(['markedPhases', phaseId], false)
      onMarkPhase: @toggleMarkPhase
      toggleAddNewTask: =>
        @props.updateLocalState(['newTask', 'phaseId'], phase.get('id'))


  _renderPhaseModal: ->
    phaseId = @props.localState.get('editingPhaseId')
    existingIds = @props.tasks.map((phase) ->
      phase.get('id'))
      .filter (pId) ->
        pId != phaseId
    React.createElement PhaseModal,
      phaseId: phaseId
      show: @isEditingPhaseId()
      onPhaseUpdate: (newId) =>
        phaseId = @props.localState.get('editingPhaseId')
        phase = @props.tasks.find( (p) -> p.get('id') == phaseId)
        @props.handlePhaseUpdate(phaseId, phase.set('id', newId))
        @hidePhaseIdEdit()
      onHide: @hidePhaseIdEdit
      existingIds: existingIds

  canMergePhases: ->
    @props.localState.get('markedPhases', Map()).find (isMarked, phase) ->
      isMarked == true

  toggleMergePhases: ->
    @props.updateLocalState('mergePhases', true)

  _renderMergePhaseModal: ->
    React.createElement MergePhasesModal,
      show: @props.localState.get('mergePhases', false)
      onHide: =>
        @props.updateLocalState('mergePhases', false)
      tasks: @props.tasks
      phases: @props.tasks.map((phase) -> phase.get('id'))
      onMergePhases: @_mergePhases

  _mergePhases: (destinationPhaseId) ->
    markedPhases = @props.localState.get('markedPhases')
    mergedTasks = List()
    # filter only those not selected and not choosed to merge to and
    # concat their tasks
    newPhases = @props.tasks.filter( (phase) ->
      pid = phase.get('id')
      isMarked = markedPhases.get(pid)
      if isMarked or destinationPhaseId == pid
        mergedTasks = mergedTasks.concat(phase.get('tasks'))
      !isMarked or destinationPhaseId == pid
    )
    found = false
    #if merging into existing phase then replace its tasks
    newPhases = newPhases.map((ph) ->
      if ph.get('id') == destinationPhaseId
        found = true
        return ph.set('tasks', mergedTasks)
      else
        return ph
    , found)
    #if not merging into existing phase then push new phase to the end
    if not found
      newPhase = Map({id: destinationPhaseId}).set('tasks', mergedTasks)
      newPhases = newPhases.push(newPhase)
    # save to the store
    @props.handlePhasesSet(newPhases)
    # reset marked phases state
    @props.updateLocalState([], Map())
    return true

  canMoveTasks: ->
    @props.localState.getIn(['moveTasks', 'marked'], Map()).find (task) ->
      task != null


  toggleMarkPhase: (phaseId, shiftKey) ->
    if not shiftKey
      marked = @props.localState.getIn(['markedPhases', phaseId], false)
      return @props.updateLocalState(['markedPhases', phaseId], !marked)
    markedPhases = @props.localState.get('markedPhases')
    isInMarkingRange = false
    isAfterMarkingRange = false
    @props.tasks.forEach (phase) =>
      pId = phase.get('id')
      marked = @props.localState.getIn(['markedPhases', pId], false)
      if marked and not isInMarkingRange
        isInMarkingRange = true
      if isInMarkingRange and not isAfterMarkingRange
        markedPhases = markedPhases.set(pId, true)
      if pId == phaseId
        isAfterMarkingRange = true
    @props.updateLocalState('markedPhases', markedPhases)


  hidePhaseIdEdit: ->
    @props.updateLocalState(['editingPhaseId'], null)

  togglePhaseIdEdit: (phaseId) ->
    @props.updateLocalState(['editingPhaseId'], phaseId)

  isEditingPhaseId: ->
    val = @props.localState.get('editingPhaseId')
    val != null and val != undefined

  isPhaseHidden: (phase) ->
    @props.localState.getIn ['phases', phase.get('id'), 'isHidden'], false

  onPhaseMove: (afterPhaseId, phaseId) ->
    @props.handlePhaseMove(phaseId, afterPhaseId)

module.exports = TasksEditTable
