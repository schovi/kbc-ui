React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)


{div, p, strong} = React.DOM

AddTaskModal = React.createClass
  displayName: 'AddTaskModal'

  render: ->
    Modal title: "Add Task", onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        p null, 'TODO'
      div className: 'modal-footer',
        ButtonToolbar null,
          Button onClick: @props.onRequestHide,
            'Cancel'
          Button bsStyle: 'primary',
            'Run'


module.exports = AddTaskModal