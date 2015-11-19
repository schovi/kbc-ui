React = require 'react'
Link = require('react-router').Link

ComponentsStore  = require('../../../../components/stores/ComponentsStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName')
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon').default)
uploadUtils = require '../../../uploadUtils'

SelectWriterModal = require('./WritersModal').default

ActivateDeactivateButton = React.createFactory(require('../../../../../react/common/ActivateDeactivateButton').default)

InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
ApplicationActionCreators = require '../../../../../actions/ApplicationActionCreators'

RoutesStore = require '../../../../../stores/RoutesStore'
{List, Map, fromJS} = require 'immutable'
{OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'

DropboxRow = React.createFactory require './DropboxRow'
GdriveRow = React.createFactory require './GdriveRow'
TableauServerRow = React.createFactory require './TableauServerRow'

{button, strong, div, h2, span, h4, section, p} = React.DOM

componentId = 'tde-exporter'
module.exports = React.createClass
  displayName: 'TDEDestination'

  mixins: [createStoreMixin(InstalledComponentsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')

    configData = InstalledComponentsStore.getConfigData(componentId, configId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)

    #state
    configId: configId
    configData: configData
    localState: localState
    isSaving: InstalledComponentsStore.isSavingConfigData(componentId, configId)
    savingData: InstalledComponentsStore.getSavingConfigData(componentId, configId)

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      React.createElement SelectWriterModal,
        localState: @state.localState.get('writersModal', Map())
        setLocalState: (key, value ) =>
          @_updateLocalState(['writersModal'].concat(key), value)
      #@_renderTableauServer()
      #@_renderDropbox()
      @_renderGoogleDrive()

  _renderGoogleDrive: ->
    parameters = @state.configData.get 'parameters'
    account = @state.configData.getIn ['parameters', 'gdrive']
    description = account?.get 'email'
    isAuthorized = uploadUtils.isGdriveAuthorized(parameters)
    GdriveRow
      configId: @state.configId
      localState: @state.localState
      updateLocalStateFn: @_updateLocalState
      account: @state.configData.getIn ['parameters', 'gdrive']
      setConfigDataFn: @_saveConfigData
      saveTargetFolderFn: (folderId, folderName) =>
        path = ['parameters', 'gdrive']
        gdrive = @state.configData.getIn path, Map()
        gdrive = gdrive.set('targetFolder', folderId)
        gdrive = gdrive.set('targetFolderName', folderName)
        @_saveConfigData(path, gdrive)
      renderComponent: =>
        @_renderComponentCol('wr-google-drive')
      renderEnableUpload: (name) =>
        @_renderEnableUploadCol('gdrive', isAuthorized, name)
      resetUploadTask: =>
        @_resetUploadTask('gdrive')


  _renderDropbox: ->
    parameters = @state.configData.get 'parameters'
    account = @state.configData.getIn ['parameters', 'dropbox']
    description = account?.get 'description'
    isAuthorized = uploadUtils.isDropboxAuthorized(parameters)
    DropboxRow
      configId: @state.configId
      localState: @state.localState
      updateLocalStateFn: @_updateLocalState
      account: @state.configData.getIn ['parameters', 'dropbox']
      setConfigDataFn: @_saveConfigData
      renderComponent: =>
        @_renderComponentCol('wr-dropbox')
      renderEnableUpload: (name) =>
        @_renderEnableUploadCol('dropbox', isAuthorized, name)
      resetUploadTask: =>
        @_resetUploadTask('dropbox')


  _renderTableauServer: ->
    parameters = @state.configData.get 'parameters'
    account = @state.configData.getIn ['parameters', 'tableauServer']
    description = account?.get 'server_url'
    isAuthorized = uploadUtils.isTableauServerAuthorized(parameters)
    TableauServerRow
      configId: @state.configId
      localState: @state.localState
      updateLocalStateFn: @_updateLocalState
      account: account
      setConfigDataFn: @_saveConfigData
      renderComponent: =>
        @_renderComponentCol('wr-tableau-server')
      renderEnableUpload: (name) =>
        @_renderEnableUploadCol('tableauServer', isAuthorized, name)
      resetUploadTask: =>
        @_resetUploadTask('tableauServer')


  _saveConfigData: (path, data) ->
    newData = @state.configData.setIn path, data
    saveFn = InstalledComponentsActions.saveComponentConfigData
    saveFn(componentId, @state.configId, fromJS(newData))


  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)

  _renderComponentCol: (pcomponentId) ->
    component = ComponentsStore.getComponent(pcomponentId)
    return span {className: ''},
      ComponentIcon {component: component, size: '32'}
      ' '
      span null,
        component.get('name')
      ' '
      button
        type: 'button'
        className: 'btn btn-success'
        onClick: @_showWritersModal
        'Change'

  _showWritersModal: ->
    @_updateLocalState(['writersModal', 'show'], true)

  _hasUploadTask: (taskName) ->
    tasks = @state.configData.getIn(['parameters', 'uploadTasks'], List())
    return tasks.find( (t) -> t == taskName)

  _toggleImmediateUpload: (taskName, isActive) ->
    tasks = @state.configData.getIn(['parameters', 'uploadTasks'], List())
    newTasks = tasks.push(taskName)
    if isActive
      newTasks = tasks.filter( (val) -> val != taskName)
    @_saveConfigData(['parameters', 'uploadTasks'], newTasks)

  _renderEnableUploadCol: (componentKey, isAuthorized, accountName) ->
    if not isAuthorized
      return div(null)

    isActive = @_hasUploadTask(componentKey) # gdrive, dropbox, # tableauServer
    isSaving = false
    if @state.isSaving
      savingTasks = @state.savingData.getIn(['parameters', 'uploadTasks'], List())
      hasTask = savingTasks.find((t) -> t == componentKey)
      if isActive
        isSaving = !hasTask
      else
        isSaving = hasTask

    helpText = "All TDE files will be uploaded to #{accountName} immediately after export."
    if not isActive
      helpText = 'No instant upload of TDE files after export.'
    span null,
      p className: 'help-block', helpText
      ActivateDeactivateButton
        mode: 'link'
        key: 'active'
        activateTooltip: 'Enable instant upload'
        deactivateTooltip: 'Disable instant upload'
        isActive: isActive
        isPending: isSaving
        onChange: =>
          @_toggleImmediateUpload(componentKey, isActive)

  _resetUploadTask: (taskName) ->
    params = @state.configData.getIn(['parameters'], Map())
    params = params.set(taskName, null)
    uploadTasks = params.get('uploadTasks', List()).filter((t) -> t != taskName)
    params = params.set('uploadTasks', uploadTasks)
    @_saveConfigData(['parameters'], params)
