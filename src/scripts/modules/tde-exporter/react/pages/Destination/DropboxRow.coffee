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


  render: ->
    div {className: 'row'},
      @props.renderComponent()
      div className: 'col-md-4',
        @_renderAuthorization()
      div className: 'col-md-3',

  _renderAuthorization: ->
    if @_isAuthorized()
      div className: 'well well-sm text-center',
        @_renderAuthorizedInfo()
    else
      div className: 'well well-sm text-center',
        div null, 'Not Authorized.'
        @_renderAuthorizeButton()

  _renderAuthorizeButton: ->
    ModalTrigger
      modal: DropboxModal
        configId: @props.configId
        redirectRouterPath: 'tde-exporter-dropbox-redirect'
        credentialsId: "tde-exporter-#{@props.configId}"
    ,
      span className: 'btn btn-primary',
        i className: 'fa fa-fw fa-dropbox'
        'Authorize Dropbox Account'


  _renderAuthorizedInfo: ->
    span null,
      'Authorized for '
      strong null,
        @props.account.get 'description'
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
            bsSize: 'small'
          ,
            'reset'


  _isAuthorized: ->
    console.log "DROPBOX IS AUTHORIZED:", Object.keys(@props.account), @props.account, @props.account?.toJS()
    @props.account and
      @props.account.has('description') and
      @props.account.has('id')
