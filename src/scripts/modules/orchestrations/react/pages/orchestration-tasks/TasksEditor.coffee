React = require 'react'
_ = require 'underscore'
Immutable = require 'immutable'

ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

TasksEditTable = React.createFactory(require './TasksEditTable')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
AddTaskModal = React.createFactory(require './../../modals/add-task/AddTaskModal')
Loader = React.createFactory(require('kbc-react-components').Loader)

{div, button, span} = React.DOM

TasksEditor = React.createClass
  displayName: 'TasksEditor'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired
    isSaving: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func.isRequired
    isParallelismEnabled: React.PropTypes.bool.isRequired
    updateLocalState: React.PropTypes.func.isRequired
    localState: React.PropTypes.object.isRequired

  render: ->
    div null,
      TasksEditTable
        tasks: @props.tasks
        components: @props.components
        disabled: @props.isSaving
        onTaskDelete: @_handleTaskDelete
        onTaskUpdate: @_handleTaskUpdate
        onTaskMove: @_handleTaskMove
        isParallelismEnabled: @props.isParallelismEnabled
        updateLocalState: @props.updateLocalState
        localState: @props.localState
        handlePhaseMove: @_handlePhaseMove
      div className: 'kbc-block-with-padding',
        ModalTrigger modal: AddTaskModal(onConfigurationSelect: @_handleTaskAdd),
          Button
            bsStyle: 'primary'
            disabled: @props.isSaving
          ,
            'Add task'

  _handleTaskDelete: (configurationId) ->
    @props.onChange(
      @props.tasks.remove(@props.tasks.findIndex((task) -> task.get('id') == configurationId))
    )

  _handleTaskUpdate: (updatedTask) ->
    @props.onChange(
      @props.tasks.set(
        @props.tasks.findIndex((task) -> task.get('id') == updatedTask.get('id')),
        updatedTask
      )
    )

  _handleTaskMove: (id, afterId) ->
    task = @props.tasks.find((task) -> task.get('id') == id)
    currentIndex = @props.tasks.findIndex((task) -> task.get('id') == id)
    afterIndex = @props.tasks.findIndex((task) -> task.get('id') == afterId)
    @props.onChange(
      @props.tasks.splice(currentIndex, 1).splice(afterIndex, 0, task)
    )

  _handlePhaseMove: (id, afterId) ->
    phase = @props.tasks.find((phase) -> phase.get('id') == id)
    currentIndex = @props.tasks.findIndex((phase) -> phase.get('id') == id)
    afterIndex = @props.tasks.findIndex((phase) -> phase.get('id') == afterId)
    @props.onChange(
      @props.tasks.splice(currentIndex, 1).splice(afterIndex, 0, phase)
    )


  _handleTaskAdd: (component, configuration) ->
    # prepare task
    task =
      id: _.uniqueId() # temporary id
      component: component.get('id')
      action: "run"
      actionParameters:
        config: configuration.get('id')
      continueOnFailure: false
      active: true
      timeoutMinutes: null

    if component.get('id') == 'gooddata-writer'
      task.action = 'upload-project'

    if _.contains ['ex-netsuite'], component.get('id')
      task.actionParameters =
        configurationId: configuration.get('id')

    if _.contains ['ex-recurly', 'ex-youtube'], component.get('id')
      task.actionParameters = {}

    @props.onChange(
      @props.tasks.push(Immutable.fromJS(task))
    )


module.exports = TasksEditor
