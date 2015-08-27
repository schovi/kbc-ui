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
        @_renderAuthorizedInfo()
      div className: 'col-md-3',
        ModalTrigger
          modal: DropboxModal
            configId: @props.configId
            redirectRouterPath: 'tde-exporter-dropbox-redirect'
            credentialsId: "tde-exporter-#{@props.configId}"
        ,
          span className: 'btn btn-primary btn-sm',
            i className: 'fa fa-fw fa-dropbox'
            if @_isAuthorized()
              'Reauthorize Dropbox Account'
            else
              'Authorize Dropbox Account'

  _renderAuthorizedInfo: ->
    if @_isAuthorized()
      span null,
        'Authorized for '
        strong null,
          @props.account.get 'description'
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
    else
      'Not Authorized'

  _isAuthorized: ->
    @props.account and
      @props.account.has('description') and
      @props.account.has('id')
