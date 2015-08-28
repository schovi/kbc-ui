React = require 'react'
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName')
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'

OrchestrationModal = require './OrchestrationModal'

RoutesStore = require '../../../../../stores/RoutesStore'
{Map, fromJS} = require 'immutable'
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

  render: ->
    console.log "DESTINATION config", @state.configData?.toJS()
    div {className: 'container-fluid kbc-main-content'},
      @_renderTableauServer()
      @_renderDropbox()
      @_renderGoogleDrive()

  _renderGoogleDrive: ->
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

  _renderDropbox: ->
    DropboxRow
      configId: @state.configId
      localState: @state.localState
      updateLocalStateFn: @_updateLocalState
      account: @state.configData.getIn ['parameters', 'dropbox']
      setConfigDataFn: @_saveConfigData
      renderComponent: =>
        @_renderComponentCol('wr-dropbox')

  _renderTableauServer: ->
    TableauServerRow
      configId: @state.configId
      localState: @state.localState
      updateLocalStateFn: @_updateLocalState
      account: @state.configData.getIn ['parameters', 'tableauServer']
      setConfigDataFn: @_saveConfigData
      renderComponent: =>
        @_renderComponentCol('wr-tableau-server')

  _renderOrchestrationModal: (uploadComponentId) ->
    OrchestrationModal
      uploadComponentId: uploadComponentId
      updateLocalStateFn: (path, data) =>
        path = ['orchestrationModal'].concat path
        @_updateLocalState(path, data)
      localState: @state.localState.get('orchestrationModal', Map())


  _saveConfigData: (path, data) ->
    newData = @state.configData.setIn path, data
    saveFn = InstalledComponentsActions.saveComponentConfigData
    saveFn(componentId, @state.configId, fromJS(newData))


  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)

  _renderComponentCol: (pcomponentId) ->
    component = ComponentsStore.getComponent(pcomponentId)
    div {className: 'col-md-3'},
      span {className: ''},
        ComponentIcon {component: component, size: '32'}
        ' '
        span null,
          component.get('name')
