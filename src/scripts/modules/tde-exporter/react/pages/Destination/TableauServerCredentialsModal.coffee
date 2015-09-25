React = require 'react'
_ = require 'underscore'
{ModalFooter, Modal, ModalHeader, ModalTitle, ModalBody} = require('react-bootstrap')
{button, strong, div, h2, span, h4, section, p} = React.DOM
ApplicationStore = require '../../../../../stores/ApplicationStore'
{Map} = require 'immutable'
{Loader} = require 'kbc-react-components'

Button = React.createFactory(require('react-bootstrap').Button)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
RouterStore = require('../../../../../stores/RoutesStore')
{i, span, div, p, strong, form, input, label, div} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)

module.exports = React.createClass
  displayName: 'TableauServerCredentialsModal'

  propTypes:
    saveCredentialsFn: React.PropTypes.func.isRequired

  getInitialState: ->
    credentials: @props.credentials or Map()
    isSaving: false


  render: ->
    show = !!@props.localState?.get('show')
    React.createElement Modal,
      show: show
      onHide: =>
        @props.updateLocalState(Map())
      title: 'Setup Credentials to Tableau Server'
    ,

      div className: 'form form-horizontal',
        div className: 'modal-body',
          @_createInput('Server URL', 'server_url')
          @_createInput('Username', 'username')
          @_createInput('Password', 'password', 'password')
          @_createInput('Project Id', 'project_id')
        div className: 'modal-footer',
          ButtonToolbar null,
            if @state.isSaving
              React.createElement Loader
            Button
              onClick: =>
                @props.updateLocalState(Map())
              bsStyle: 'link'
            ,
              'Cancel'
            Button
              bsStyle: 'success'
              disabled: not @_isValid() or @state.isSaving
              onClick: =>
                @setState
                  isSaving: true
                @props.saveCredentialsFn(@state.credentials).then =>
                  @setState
                    isSaving: false
                  @props.updateLocalState(Map())
            ,
              span null,
                'Save '
  _isValid: ->
    @state.credentials and
      not _.isEmpty(@state.credentials.get('server_url')) and
      not _.isEmpty(@state.credentials.get('username')) and
      not _.isEmpty(@state.credentials.get('project_id')) and
      not _.isEmpty(@state.credentials.get('password'))


  _createInput: (labelValue, propName, type = 'text', isProtected = false) ->
    Input
      label: labelValue
      type: type
      value: @state.credentials.get propName
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      onChange: (event) =>
        value = event.target.value
        credentials = @state.credentials.set(propName, value)
        @setState
          credentials: credentials
