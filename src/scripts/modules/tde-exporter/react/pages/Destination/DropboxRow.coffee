React = require 'react'
_ = require 'underscore'
oauthActions = require '../../../../components/OAuthActionCreators'

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
DropboxModal = React.createFactory require '../../../../components/react/components/DropboxAuthorizeModal'
{i, button, strong, div, h2, span, h4, section, p} = React.DOM
{OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'
Button = React.createFactory(Button)
{Map} = require 'immutable'
Confirm = require '../../../../../react/common/Confirm'

module.exports = React.createClass
  displayName: 'DropboxRow'

  propTypes:
    updateLocalStateFn: React.PropTypes.func
    localState: React.PropTypes.object
    configId: React.PropTypes.string
    account: React.PropTypes.object
    orchestrationModal: React.PropTypes.object

  render: ->
    div {className: 'row'},
      @props.renderComponent()
      div className: 'col-md-4',
        @_renderAuthorization()
      div className: 'col-md-3',
        if !@_isAuthorized()
          div null,
            @_renderAuthorizeButton()
        @props.orchestrationModal
        if @_isAuthorized()
          div null,
            React.createElement Confirm,
              title: 'Reset Authorization'
              text: "Do you really want to reset authorization for #{@props.account.get('description')}"
              buttonLabel: 'Reset'
              onConfirm: =>
                @props.setConfigDataFn(['parameters', 'dropbox'], null)
                oauthActions.deleteCredentials('wr-dropbox', @props.account.get('id'))
            ,
              Button
                bsStyle: 'link'
              ,
                span className: 'kbc-icon-cup fa-fw'
                ' Reset Authorization'


  _renderAuthorization: ->
    if @_isAuthorized()
      span null,
        'Authorized for '
        strong null,
          @props.account.get 'description'
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
        bsStyle: 'link'
      ,
        span className: 'fa fa-fw fa-dropbox'
        ' Authorize'

  _isAuthorized: ->
    @props.account and
      @props.account.has('description') and
      @props.account.has('id')
