React = require 'react'
Immutable = require 'immutable'
{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)

InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
TablesByBucketsPanel = React.createFactory require('../../components/TablesByBucketsPanel')
{span, button, strong, div} = React.DOM

componentId = 'wr-dropbox'

module.exports = React.createClass
  displayName: 'wrDropboxIndex'
  mixins: [createStoreMixin(InstalledComponentsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    configData = InstalledComponentsStore.getConfigData(componentId, configId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    toggles = localState.get('bucketToggles') or Immutable.Map()

    # state
    configId: configId
    configData: configData
    localState: localState
    bucketToggles: toggles

  render: ->
    div {className: 'container-fluid'},
      @_renderMainContent()
      @_renderSideBar()

  _renderMainContent: ->
    div {className: 'col-md-9 kbc-main-content'},
      div className: 'row',
        ComponentDescription
          componentId: 'wr-dropbox'
          configId: @state.configId
      div className: 'row',
        TablesByBucketsPanel
          renderTableRowFn: @_renderTableRow
          renderHeaderRowFn: @_renderHeaderRow
          filterFn: @_filterBuckets
          onSearchQueryChange: @_handleSearchQueryChange
          searchQuery: @state.localState.get('searchQuery') or ''
          isTableExportedFn: @_isTableExported
          onToggleBucketFn: @_handleToggleBucket
          isBucketToggledFn: @_isBucketToggled


  _renderTableRow: (table) ->
    div {className: 'tr', key: table.get('id')},
      span className: 'td',
        table.get 'name'
      span className: 'td text-right',
        React.createElement ActivateDeactivateButton,
          activateTooltip: 'Enable Export'
          deactivateTooltip: 'Disable Export'
          isActive: true
          isPending: false
          onChange: @_handleExportChange
        React.createElement Tooltip,
          tooltip: 'Upload table to Dropbox'
        ,
          React.createElement Confirm,
            text: 'Upload Table'
            title: 'Upload Table'
            buttonLabel: 'Upload'
            buttonType: 'success'
            onConfirm: @_handleUpload
          ,
            button className: 'btn btn-link',
              span className: 'fa fa-upload fa-fw'


  _renderHeaderRow: ->
    div className: 'tr',
      span className: 'th',
        strong null, 'Table name'
    return null


  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      "SIDE BAR TODO"

  _handleExportChange: ->


  _filterBuckets: (buckets) ->
    buckets = buckets.filter (bucket) ->
      bucket.get('stage') == 'out'
    return buckets


  _isTableExportedFn: (table) ->
    return false

  _handleToggleBucket: (bucketId) ->
    newValue = !@_isBucketToggled(bucketId)
    newToggles = @state.bucketToggles.set(bucketId, newValue)
    @_updateLocalState(['bucketToggles'], newToggles)

  _isBucketToggled: (bucketId) ->
    !!@state.bucketToggles.get(bucketId)

  _handleSearchQueryChange: (newQuery) ->
    @_updateLocalState(['searchQuery'], newQuery)

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn path, data
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
