React = require 'react'
_ = require 'underscore'
#DropboxModal = React.createFactory require './DropboxModal'
{label, input, button, strong, div, h2, span, h4, section, p, ul, li} = React.DOM
{Input, OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'
Button = React.createFactory(Button)
{Map} = require 'immutable'
Confirm = require('../../../../../react/common/Confirm').default
TableauServerCredentialsModal = React.createFactory require './TableauServerCredentialsModal'


module.exports = React.createClass
  displayName: 'TableauServerRow'

  propTypes:
    updateLocalStateFn: React.PropTypes.func
    localState: React.PropTypes.object
    configId: React.PropTypes.string
    account: React.PropTypes.object
    setConfigDataFn: React.PropTypes.func
    renderEnableUpload: React.PropTypes.func
    resetUploadTask: React.PropTypes.func
    orchestrationModal: React.PropTypes.object

  render: ->
    div {className: 'row'},
      @props.renderComponent()
      div className: 'col-md-3',
        @_renderAuthorized()
      div className: 'col-md-3',
        if !@_isAuthorized()
          div null,
            @_renderAuthorizeButton('Setup credentials to Tableau Server')
        if @_isAuthorized()
          div null,
            @_renderAuthorizeButton('Edit Credentials')
        if @_isAuthorized()
          div null,
            React.createElement Confirm,
              title: 'Delete Credentials'
              text: "Do you really want to delete credentials for #{@props.account.get('server_url')}"
              buttonLabel: 'Delete'
              onConfirm: =>
                @props.resetUploadTask()
            ,
              Button
                bsStyle: 'link'
              ,
                span className: 'kbc-icon-cup fa-fw'
                ' Disconnect Destination'
      @props.renderEnableUpload()

  _renderAuthorized: ->
    if @_isAuthorized()
      span null,
        'Authorized for '
        strong null,
          "#{@props.account.get('username')}@#{@props.account.get('server_url')}"
    else
      span null,
        'No Credentials.'

  _renderAuthorizeButton: (caption) ->
    Button
      bsStyle: 'link'
      onClick: =>
        @props.updateLocalStateFn(['tableauServerModal', 'show'], true)
    ,
      span className: 'fa fa-fw fa-user'
      ' ' + caption
      TableauServerCredentialsModal
        configId: @props.configId
        localState: @props.localState.get('tableauServerModal', Map())
        updateLocalState: (data) =>
          @props.updateLocalStateFn(['tableauServerModal'], data)
        credentials: @props.account
        saveCredentialsFn: (credentials) =>
          path = ['parameters', 'tableauServer']
          @props.setConfigDataFn(path, credentials)

  _isAuthorized: ->
    passwordEmpty = true
    if @props.account
      password = @props.account.get('password')
      hashPassword = @props.account.get('#password')
      passwordEmpty =  _.isEmpty(password) && _.isEmpty(hashPassword)
    @props.account and
      not _.isEmpty(@props.account.get('server_url')) and
      not _.isEmpty(@props.account.get('username')) and
      not _.isEmpty(@props.account.get('project_name')) and
      not passwordEmpty
