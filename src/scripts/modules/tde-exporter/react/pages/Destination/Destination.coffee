React = require 'react'
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName')
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'

RoutesStore = require '../../../../../stores/RoutesStore'
{Map, fromJS} = require 'immutable'
{OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'


GdriveRow = React.createFactory require './GdriveRow'

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
      @_renderGoogleDrive()
      @_renderDropbox()
      @_renderTableauServer()

  _renderGoogleDrive: ->
    gdriveComponentId = 'wr-google-drive'
    component = ComponentsStore.getComponent(gdriveComponentId)

    GdriveRow
      configId: @state.configId
      localState: @state.localState
      updateLocalStateFn: @_updateLocalState
      account: @state.configData.getIn ['parameters', 'gdrive']
      setConfigDataFn: @_saveConfigData
      renderComponent: ->
        div {className: 'col-md-4'},
          span {className: ''},
            ComponentIcon {component: component, size: '32'}
            ' '
            ComponentName {component: component}




  _renderDropbox: ->
    dropboxComponentId = 'wr-dropbox'
    component = ComponentsStore.getComponent(dropboxComponentId)
    div {className: 'row'},
      div {className: 'col-md-4'},
        span {className: ''},
          ComponentIcon {component: component, size: '32'}
          ' '
          ComponentName {component: component}

  _renderTableauServer: ->
    tableauComponentId = 'wr-tableau-server'
    component = ComponentsStore.getComponent(tableauComponentId)
    div {className: 'row'},
      div {className: 'col-md-4'},
        span {className: ''},
          ComponentIcon {component: component, size: '32'}
          ' '
          ComponentName {component: component}

  _saveConfigData: (path, data) ->
    newData = @state.configData.setIn path, data
    saveFn = InstalledComponentsActions.saveComponentConfigData
    saveFn(componentId, @state.configId, fromJS(newData))


  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
