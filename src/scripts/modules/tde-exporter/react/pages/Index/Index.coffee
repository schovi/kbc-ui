React = require 'react'
{Map} = require 'immutable'

InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
StorageFilesStore = require '../../../../components/stores/StorageFilesStore'
RoutesStore = require '../../../../../stores/RoutesStore'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TableRow = require './TableRow'
SapiTableSelector = require '../../../../components/react/components/SapiTableSelector'
{ModalFooter, Modal, ModalHeader, ModalTitle, ModalBody} = require('react-bootstrap')

ConfirmButtons = require '../../../../../react/common/ConfirmButtons'
ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'
DeleteConfigurationButton = require '../../../../components/react/components/DeleteConfigurationButton'
TablesByBucketsPanel = React.createFactory require('../../../../components/react/components/TablesByBucketsPanel')
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'


componentId = 'tde-exporter'
{p, ul, li, span, button, strong, div, i} = React.DOM

module.exports = React.createClass
  displayName: 'tdeindex'
  mixins: [createStoreMixin(InstalledComponentsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    configData = InstalledComponentsStore.getConfigData(componentId, configId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    typedefs = configData.getIn(['parameters', 'typedefs'], Map()) or Map()
    console.log StorageFilesStore.getAll().toJS()

    #state
    configId: configId
    configData: configData
    localState: localState
    typedefs: typedefs

  render: ->
    console.log @state.configData.toJS()
    div {className: 'container-fluid'},
      @_renderMainContent()
      @_renderSideBar()

  _renderMainContent: ->
    div {className: 'col-md-9 kbc-main-content'},
      div className: 'row kbc-header',
        div className: 'col-sm-8',
          ComponentDescription
            componentId: componentId
            configId: @state.configId
        div className: 'col-sm-4 kbc-buttons',
          @_addNewTableButton()
          @_renderAddNewTable()
      @_renderTables()

  _renderTables: ->
    TablesByBucketsPanel
      renderTableRowFn: @_renderTableRow
      renderHeaderRowFn: @_renderHeaderRow
      filterFn: @_filterBuckets
      isTableExportedFn: (tableId) =>
        @state.typedefs?.has tableId
      onToggleBucketFn: @_handleToggleBucket
      isBucketToggledFn: @_isBucketToggled
      showAllTables: false
      toggleShowAllFn: null
      configuredTables: @state.typedefs?.keySeq().toJS()
      #renderDeletedTableRowFn: (table) =>
      #  @_renderTableRow(table, true)

  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      div className: 'kbc-buttons kbc-text-light',
        React.createElement ComponentMetadata,
          componentId: componentId
          configId: @state.configId
      ul className: 'nav nav-stacked',
        li null,
          React.createElement DeleteConfigurationButton,
            componentId: componentId
            configId: @state.configId

  _renderTableRow: (table, isDeleted = false) ->
    tableId = table.get 'id'
    React.createElement TableRow,
      table: table
      configId: @state.configId

  _filterBuckets: (buckets) ->
    buckets = buckets.filter (bucket) ->
      bucket.get('stage') == 'out' or bucket.get('stage') == 'in'
    return buckets

  _renderAddNewTable: ->
    show = !!@state.localState?.getIn(['newTable','show'])
    React.createElement Modal,
      show: show
      onHide: =>
        @_updateLocalState(['newTable'], Map())
      React.createElement ModalHeader, {closeButton: true},
        React.createElement  ModalTitle, null, 'Add Table'
      React.createElement ModalBody, null,
        React.createElement SapiTableSelector,
          value: @state.localState?.getIn(['newTable', 'id'])
          onSelectTableFn: (value) =>
            @_updateLocalState(['newTable', 'id'], value)
          excludeTableFn: (tableId) =>
            @state.configData.hasIn ['parameters', 'typedefs',tableId]
      React.createElement ModalFooter, null,
        React.createElement ConfirmButtons,
          isSaving: false
          isDisabled: not !! @state.localState?.getIn(['newTable', 'id'])
          cancelLabel: 'Cancel'
          saveLabel: 'Select'
          onCancel: =>
            @_updateLocalState(['newTable'], Map())
          onSave: =>
            RoutesStore.getRouter().transitionTo("tde-exporter-table",
              config: @state.configId
              tableId: @state.localState?.getIn(['newTable', 'id'])
            )
            @_updateLocalState(['newTable'], Map())





  _addNewTableButton: ->
    button
      className: 'btn btn-success'
      onClick: =>
        @_updateLocalState(['newTable', 'show'], true)
      span className: 'kbc-icon-plus'
      ' Add Table'

  _renderHeaderRow: ->
    div className: 'tr',
      span className: 'th',
        strong null, 'Table name'
      span className: 'th',
        strong null, 'Last TDE File'
      span className: 'th',
        strong null, ''


  _handleToggleBucket: (bucketId) ->
    newValue = !@_isBucketToggled(bucketId)
    bucketToggles = @state.localState.get 'bucketToggles', Map()
    newToggles = bucketToggles.set(bucketId, newValue)
    @_updateLocalState(['bucketToggles'], newToggles)

  _isBucketToggled: (bucketId) ->
    bucketToggles = @state.localState.get 'bucketToggles', Map()
    !!bucketToggles.get(bucketId)

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
