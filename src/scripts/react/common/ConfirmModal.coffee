React = require 'react'

Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

{div, p} = React.DOM


ConfirmModal = React.createClass
  displayName: 'ConfirmModal'

  render: ->
    Modal title: @props.title, onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        p null,
          @props.text
      div className: 'modal-footer',
        ButtonToolbar null,
          Button
            onClick: @props.onRequestHide
            bsStyle: 'link'
          ,
            'Cancel'
          Button
            bsStyle: @props.buttonType
            onClick: @_handleConfirm
          ,
            @props.buttonLabel

  _handleConfirm: ->
    @props.onRequestHide()
    @props.onConfirm()

module.exports = ConfirmModal
