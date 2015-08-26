React = require 'react'
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName')
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'

RoutesStore = require '../../../../../stores/RoutesStore'
{Map} = require 'immutable'
{OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'

GdriveModal = React.createFactory require './AuthorizeGdriveModal'

{strong, div, h2, span, h4, section, p} = React.DOM

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
    div {className: 'container-fluid kbc-main-content'},
      @_renderGoogleDrive()
      @_renderDropbox()
      @_renderTableauServer()

  _renderGoogleDrive: ->
    componentId = 'wr-google-drive'
    component = ComponentsStore.getComponent(componentId)
    div {className: 'row'},
      div {className: 'col-md-4'},
        span {className: ''},
          ComponentIcon {component: component, size: '32'}
          ' '
          ComponentName {component: component}
      div className: 'col-md-8',
        React.createElement Button,
          onClick: =>
            @_updateLocalState(['gdrivemodal', 'show'], true)
        ,
          'Authorize Account Now'
        GdriveModal
          configId: @state.configId
          localState: @state.localState.get('gdrivemodal', Map())
          updateLocalState: (data) =>
            @_updateLocalState(['gdrivemodal'], data)


  _renderDropbox: ->
    componentId = 'wr-dropbox'
    component = ComponentsStore.getComponent(componentId)
    div {className: 'row'},
      div {className: 'col-md-4'},
        span {className: ''},
          ComponentIcon {component: component, size: '32'}
          ' '
          ComponentName {component: component}

  _renderTableauServer: ->
    componentId = 'wr-tableau-server'
    component = ComponentsStore.getComponent(componentId)
    div {className: 'row'},
      div {className: 'col-md-4'},
        span {className: ''},
          ComponentIcon {component: component, size: '32'}
          ' '
          ComponentName {component: component}

  _renderModal: (title, modalBody, modalFooter) ->
    show = !!@state.localState?.getIn([title, 'show'])
    React.createElement Modal,
      show: show
      onHide: =>
        @_updateLocalState([title], Map())
      React.createElement ModalHeader, {closeButton: true},
        React.createElement  ModalTitle, null, title
      React.createElement ModalBody, null,
        modalBody
      React.createElement ModalFooter, null,




  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
