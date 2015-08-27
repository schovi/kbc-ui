React = require 'react'
_ = require 'underscore'
GdriveModal = React.createFactory require './AuthorizeGdriveModal'
{button, strong, div, h2, span, h4, section, p} = React.DOM
{OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'
Button = React.createFactory(Button)
{Map} = require 'immutable'
Confirm = require '../../../../../react/common/Confirm'

module.exports = React.createClass
  displayName: 'GdriveRow'

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
        Button
          bsSize: 'small'
          className: 'btn btn-primary'
          onClick: =>
            @props.updateLocalStateFn(['gdrivemodal', 'show'], true)
        ,
          if @_isAuthorized()
            'Reauthorize Google Drive Account'
          else
            'Authorize Google Drive Account'
        GdriveModal
          configId: @props.configId
          localState: @props.localState.get('gdrivemodal', Map())
          updateLocalState: (data) =>
            @props.updateLocalStateFn(['gdrivemodal'], data)

  _renderAuthorizedInfo: ->
    if @_isAuthorized()
      span null,
        'Authorized for '
        strong null,
          @props.account.get 'email'
        React.createElement Confirm,
          title: 'Reset Authorization'
          text: "Do you really want to reset authorization for #{@props.account.get('email')}"
          buttonLabel: 'Reset'
          onConfirm: =>
            @props.setConfigDataFn(['parameters', 'gdrive'], null)
        ,
          Button
            bsSize: 'small'
          ,
            'reset'
    else
      'Not Authorized'

  _isAuthorized: ->
    @props.account and
      not _.isEmpty(@props.account.get('accessToken')) and
      not _.isEmpty(@props.account.get('refreshToken')) and
      not _.isEmpty(@props.account.get('email'))
