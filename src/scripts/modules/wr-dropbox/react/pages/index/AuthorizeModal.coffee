React = require 'react'

ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
Modal = React.createFactory(require('react-bootstrap').Modal)
Input = React.createFactory(require('react-bootstrap').Input)

{i, span, div, p, strong, form, input, label, div} = React.DOM

module.exports = React.createClass
  displayName: "DropboxAuthorizeModal"

  getInitialState: ->
    description: ""

  render: ->
    Modal
      title: 'Authorize Dropbox Account'
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        div className: 'form-horizontal',
          Input
            label: "Dropbox Email"
            type: 'text'
            help: 'Used afterwards as a description of the authorized account'
            labelClassName: 'col-xs-3'
            wrapperClassName: 'col-xs-9'
            defaultValue: @state.desription
            onChange: (event) =>
              @setState
                description: event.target.value




      div className: 'modal-footer',
        ButtonToolbar null,
          Button
            onClick: @props.onRequestHide
            bsStyle: 'link'
          ,
            'Cancel'
          Button
            onClick: @_handleConfirm
            bsStyle: 'success'
          ,
            span null,
              'Authorize '
              i className: 'fa fa-fw fa-dropbox'


  _handleConfirm: ->
