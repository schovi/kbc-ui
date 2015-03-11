React = require 'react'

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
ConfirmModal = React.createFactory(require './ConfirmModal')

Confirm = React.createClass
  displayName: 'Confirm'
  propTypes:
    title: React.PropTypes.string.isRequired
    text: React.PropTypes.string.isRequired
    onConfirm: React.PropTypes.func.isRequired
    buttonLabel: React.PropTypes.string.isRequired
    buttonType: React.PropTypes.string


  getDefaultProps: ->
    buttonType: 'danger'

  render: ->
    child = React.Children.only @props.children


    ModalTrigger
      modal: ConfirmModal(@props)
    ,
      React.addons.cloneWithProps child,
        onClick: (e) ->
          e.preventDefault()
          e.stopPropagation()

module.exports = Confirm
