React = require 'react'
_ = require 'underscore'
#DropboxModal = React.createFactory require './DropboxModal'
{form, label, input, button, strong, div, h2, span, h4, section, p, ul, li} = React.DOM
{FormControls, OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'
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

  render: ->
    div className: 'row',
      form {className: 'form form-horizontal'},
        @_renderFormElement('Destination', @props.renderComponent())
        @_renderFormElement(null , @_renderCredentialsSetup())

        if @_isAuthorized()
          @_renderFormElement(null, @props.renderEnableUpload(@_accountName()))


  _renderFormElement: (label, content) ->
    cl = 'col-xs-10'
    if not label
      cl = 'col-xs-offset-2 col-xs-10'
    React.createElement FormControls.Static,
      labelClassName: if label then 'col-xs-2'
      wrapperClassName: cl
      label: label
    ,
      content

  _renderCredentialsSetup: ->
    div null,
      @_renderAuthorized()
      if !@_isAuthorized()
        @_renderAuthorizeButton('Setup credentials to Tableau Server')
      if @_isAuthorized()
        @_renderAuthorizeButton('Edit Credentials')
      if @_isAuthorized()
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


  _accountName: ->
    if @props.account
      return "#{@props.account.get('username')}@#{@props.account.get('server_url')}"
    else
      return ''

  _renderAuthorized: ->
    if @_isAuthorized()
      div null,
        'Authorized for '
        strong null,
          @_accountName()
    else
      div null,
        'No Credentials.'

  _renderAuthorizeButton: (caption) ->
    Button
      bsStyle: 'link'
      style: {'padding-left': 0}
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
