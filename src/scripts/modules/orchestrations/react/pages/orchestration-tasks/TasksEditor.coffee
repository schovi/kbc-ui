React = require 'react'

TasksEditTable = React.createFactory(require './TasksEditTable.coffee')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
AddTaskModal = React.createFactory(require './../../modals/add-task/AddTaskModal.coffee')

{div, button} = React.DOM

TasksEditor = React.createClass
  displayName: 'TasksEditor'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired

  render: ->
    div null,
      TasksEditTable
        tasks: @props.tasks
        components: @props.components
      ModalTrigger modal: AddTaskModal(onConfigurationSelect: @_handleTaskAdd),
        button className: 'btn btn-primary',
          'Add task'

  _handleTaskAdd: (configuration) ->
    console.log 'configuration added', configuration.toJS()


module.exports = TasksEditor

