React = require 'react'
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName')
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))
uploadUtils = require '../../../uploadUtils'

InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'

OrchestrationModal = require './OrchestrationModal'

RoutesStore = require '../../../../../stores/RoutesStore'
{Map, fromJS} = require 'immutable'
{OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'

DropboxRow = React.createFactory require './DropboxRow'
GdriveRow = React.createFactory require './GdriveRow'
TableauServerRow = React.createFactory require './TableauServerRow'

OrchestrationsStore = require '../../../../../modules/orchestrations/stores/OrchestrationsStore'
OrchestrationsActions = require '../../../../../modules/orchestrations/ActionCreators'

{button, strong, div, h2, span, h4, section, p} = React.DOM

componentId = 'tde-exporter'
module.exports = React.createClass
  displayName: 'TDEDestination'

  mixins: [createStoreMixin(InstalledComponentsStore, OrchestrationsStore)]


  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')

    configData = InstalledComponentsStore.getConfigData(componentId, configId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    orchestrations = OrchestrationsStore.getAll()
    #loadingOrchestrations
    isLoadingOrchestrations = OrchestrationsStore.getIsLoading()

    console.log 'ORCHESTRAIONS', orchestrations?.toJS()

    #state
    isLoadingOrchestrations: isLoadingOrchestrations
    orchestrations: orchestrations
    configId: configId
    configData: configData
    localState: localState

  componentDidMount: ->
    OrchestrationsActions.loadOrchestrations()

  render: ->
    console.log "DESTINATION config", @state.configData?.toJS()
    div {className: 'container-fluid kbc-main-content'},
      @_renderTableauServer()
      @_renderDropbox()
      @_renderGoogleDrive()

  _renderGoogleDrive: ->
    account = @state.configData.getIn ['parameters', 'gdrive']
    description = account?.get 'email'
    GdriveRow
      orchestrationModal: @_renderOrchestrationModal('wr-google-drive', description, account)
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
    account = @state.configData.getIn ['parameters', 'dropbox']
    description = account?.get 'description'

    DropboxRow
      orchestrationModal: @_renderOrchestrationModal('wr-dropbox', description, account)
      configId: @state.configId
      localState: @state.localState
      updateLocalStateFn: @_updateLocalState
      account: @state.configData.getIn ['parameters', 'dropbox']
      setConfigDataFn: @_saveConfigData
      renderComponent: =>
        @_renderComponentCol('wr-dropbox')

  _renderTableauServer: ->
    account = @state.configData.getIn ['parameters', 'tableauServer']
    description = account?.get 'server_url'

    TableauServerRow
      orchestrationModal: @_renderOrchestrationModal('wr-tableau-server', description, account)
      configId: @state.configId
      localState: @state.localState
      updateLocalStateFn: @_updateLocalState
      account: account
      setConfigDataFn: @_saveConfigData
      renderComponent: =>
        @_renderComponentCol('wr-tableau-server')

  _renderOrchestrationModal: (uploadComponentId, description, account) ->
    pathId = "#{uploadComponentId}orchModal"
    return React.createElement OrchestrationModal,
      description: description or uploadComponentId
      uploadComponentId: uploadComponentId
      updateLocalStateFn: (path, data) =>
        path = [pathId].concat path
        @_updateLocalState(path, data)
      localState: @state.localState.get(pathId, Map())
      orchestrationsList: @state.orchestrations
      isLoadingOrchestrations: @state.isLoadingOrchestrations
      selectOrchestrationFn: (orchId) =>
        path = ['orchSelect']
        @_updateLocalState(path, orchId)
      selectedOrchestration: @state.localState.get('orchSelect')
      onAppendClick: =>
        @_appendToOrchestration(uploadComponentId, account)
      isAppending: @state.localState.get('isAppending')


  _appendToOrchestration: (uploadComponentId, account) ->
    orchId = @state.localState.get 'orchSelect'
    @_updateLocalState(['isAppending'], true)
    uploadUtils.appendToOrchestration(orchId, @state.configId, uploadComponentId, account).then =>
      @_updateLocalState(['isAppending'], false)
      @_updateLocalState(["#{uploadComponentId}orchModal", 'show'], false)

    .catch (err) =>
      @_updateLocalState(['isAppending'], false)
      throw err




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
