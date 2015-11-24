React = require 'react'
_ = require 'underscore'
oauthActions = require '../../../../components/OAuthActionCreators'

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
DropboxModal = React.createFactory require '../../../../components/react/components/DropboxAuthorizeModal'
{i, button, strong, div, h2, span, form, h4, section, p} = React.DOM
{FormControls, OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'
Button = React.createFactory(Button)
{Map} = require 'immutable'
Confirm = require('../../../../../react/common/Confirm').default

module.exports = React.createClass
  displayName: 'DropboxRow'

  propTypes:
    updateLocalStateFn: React.PropTypes.func
    localState: React.PropTypes.object
    configId: React.PropTypes.string
    account: React.PropTypes.object
    renderEnableUpload: React.PropTypes.func
    resetUploadTask: React.PropTypes.func

  render: ->
    div {className: 'row'},
      form {className: 'form form-horizontal'},
        @_renderFormElement('Destination', @props.renderComponent())
        @_renderFormElement(null , @_renderAuthorizedInfo())
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

  _renderAuthorizedInfo: ->
    div null,
      @_renderAuthorization()
      if !@_isAuthorized()
        div null,
          @_renderAuthorizeButton()
      if @_isAuthorized()
        div null,
          React.createElement Confirm,
            title: 'Reset Authorization'
            text: "Do you really want to reset authorization for #{@props.account.get('description')}"
            buttonLabel: 'Reset'
            onConfirm: =>
              @props.resetUploadTask()
              #@props.setConfigDataFn(['parameters', 'dropbox'], null)
              oauthActions.deleteCredentials('wr-dropbox', @props.account.get('id'))
          ,
            Button
              bsStyle: 'link'
            ,
              span className: 'kbc-icon-cup fa-fw'
              ' Reset Authorization'


  _accountName: ->
    @props.account?.get 'description'


  _renderAuthorization: ->
    if @_isAuthorized()
      span null,
        'Authorized for '
        strong null,
          @_accountName()
    else
      span null,
        'Not Authorized.'

  _renderAuthorizeButton: ->
    ModalTrigger
      modal: DropboxModal
        configId: @props.configId
        redirectRouterPath: 'tde-exporter-dropbox-redirect'
        credentialsId: "tde-exporter-#{@props.configId}"
    ,
      Button
        style: {'padding-left': 0}
        bsStyle: 'link'
      ,
        span className: 'fa fa-fw fa-dropbox'
        ' Authorize'

  _isAuthorized: ->
    @props.account and
      @props.account.has('description') and
      @props.account.has('id')
