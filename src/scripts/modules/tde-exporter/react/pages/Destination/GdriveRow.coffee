React = require 'react'
_ = require 'underscore'
GdriveModal = React.createFactory require './AuthorizeGdriveModal'
{i, form, button, strong, div, h2, span, h4, section, p} = React.DOM
{OverlayTrigger, FormControls, Tooltip, Button} = require 'react-bootstrap'
Button = React.createFactory(Button)
{Map} = require 'immutable'
Picker = React.createFactory(require '../../../../google-utils/react/GooglePicker')
ViewTemplates = require '../../../../google-utils/react/PickerViewTemplates'
Loader = React.createFactory(require('kbc-react-components').Loader)

Confirm = require('../../../../../react/common/Confirm').default

module.exports = React.createClass
  displayName: 'GdriveRow'

  propTypes:
    updateLocalStateFn: React.PropTypes.func
    localState: React.PropTypes.object
    configId: React.PropTypes.string
    account: React.PropTypes.object
    saveTargetFolderFn: React.PropTypes.func
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
    return div null,
      @_renderAuthorization()
      if !@_isAuthorized()
        div null,
          @_renderAuthorizeButton()
      if @_isAuthorized()
        div null,
          @_renderPicker()
      if @_isAuthorized()
        div null,
          React.createElement Confirm,
            title: 'Reset Authorization'
            text: "Do you really want to reset authorization for #{@props.account.get('email')}"
            buttonLabel: 'Reset'
            onConfirm: =>
              @props.resetUploadTask()
              #@props.setConfigDataFn(['parameters', 'gdrive'], null)
          ,
            Button
              bsStyle: 'link'
            ,
              span className: 'kbc-icon-cup fa-fw'
              ' Reset Authorization'

  _accountName: ->
    @props.account?.get 'email'

  _renderAuthorization: ->
    if @_isAuthorized()
      div null,
        div null,
          'Authorized for '
          strong null,
            @_accountName()
        div null,
          'Folder '
          strong null,
            @props.account.get('targetFolderName') || '/'
    else
      span null,
        'Not Authorized.'


  _renderAuthorizeButton: ->
    div null,
      Button
        bsStyle: 'link'
        style: {'padding-left': 0}
        onClick: =>
          @props.updateLocalStateFn(['gdrivemodal', 'show'], true)
      ,
        i className: 'fa fa-fw fa-google'
        'Authorize'
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
      buttonLabel: span null,
        span className: 'fa fa-fw fa-folder-o'
        ' Select a folder'
      onPickedFn: (data) =>
        data = _.filter data, (file) ->
          file.type == 'folder'
        console.log "PICKED folder", data
        folderId = data[0].id
        folderName = data[0].name
        data[0].title = folderName
        @props.saveTargetFolderFn(folderId, folderName)
      buttonProps:
        bsStyle: 'link'
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
