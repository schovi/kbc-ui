React = require 'react'
_ = require 'underscore'
GdriveModal = React.createFactory require './AuthorizeGdriveModal'
{i, button, strong, div, h2, span, h4, section, p} = React.DOM
{OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'
Button = React.createFactory(Button)
{Map} = require 'immutable'
Picker = React.createFactory(require '../../../../google-utils/react/GooglePicker')
ViewTemplates = require '../../../../google-utils/react/PickerViewTemplates'
Loader = React.createFactory(require('kbc-react-components').Loader)

Confirm = require '../../../../../react/common/Confirm'

module.exports = React.createClass
  displayName: 'GdriveRow'

  propTypes:
    updateLocalStateFn: React.PropTypes.func
    localState: React.PropTypes.object
    configId: React.PropTypes.string
    account: React.PropTypes.object
    saveTargetFolderFn: React.PropTypes.func
    orchestrationModal: React.PropTypes.object
  render: ->
    div {className: 'row'},
      @props.renderComponent()
      div className: 'col-md-5',
        @_renderAuthorization()
      div className: 'col-md-3',
        @props.orchestrationModal

  _renderAuthorization: ->
    if @_isAuthorized()
      div className: 'well well-sm text-center',
        @_renderAuthorizedInfo()
    else
      div className: 'well well-sm text-center',
        div null, 'Not Authorized.'
        @_renderAuthorizeButton()


  _renderAuthorizedInfo: ->
    span null,
      'Authorized for '
      strong null,
        @props.account.get 'email'
      div null,
        @_renderPicker()
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

  _renderAuthorizeButton: ->
    div null,
      Button
        #bsSize: 'small'
        className: 'btn btn-primary'
        onClick: =>
          @props.updateLocalStateFn(['gdrivemodal', 'show'], true)
      ,
        i className: 'fa fa-fw fa-google'
        'Authorize Google Drive Account'
      GdriveModal
        configId: @props.configId
        localState: @props.localState.get('gdrivemodal', Map())
        updateLocalState: (data) =>
          @props.updateLocalStateFn(['gdrivemodal'], data)

  _renderPicker: ->
    file = @props.account
    folderId = file.get 'targetFolder'
    folderName = file.get('targetFolderName')

    Picker
      email: @props.account.get 'email'
      dialogTitle: 'Select a folder'
      buttonLabel: folderName or '/'
      onPickedFn: (data) =>
        data = _.filter data, (file) ->
          file.type == 'folder'
        console.log "PICKED folder", data
        folderId = data[0].id
        folderName = data[0].name
        data[0].title = folderName
        @props.saveTargetFolderFn(folderId, folderName)
      buttonProps:
        bsStyle: 'default'
        bsSize: 'small'
      views: [
        ViewTemplates.rootFolder
        ViewTemplates.flatFolders
        ViewTemplates.recentFolders
      ]


  _isAuthorized: ->
    @props.account and
      not _.isEmpty(@props.account.get('accessToken')) and
      not _.isEmpty(@props.account.get('refreshToken')) and
      not _.isEmpty(@props.account.get('email'))
