React = require 'react'
ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)

InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
TablesByBucketsPanel = React.createFactory require('../../components/TablesByBucketsPanel')
{span, strong, div} = React.DOM

componentId = 'wr-dropbox'

module.exports = React.createClass
  displayName: 'wrDropboxIndex'
  mixins: [createStoreMixin(InstalledComponentsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    configData = InstalledComponentsStore.getConfigData(componentId, configId)
    editingConfigData = InstalledComponentsStore.getEditingConfigData(componentId, configId)
    # state
    configId: configId
    configData: configData
    editingConfigData: editingConfigData
    searchQuery: ''


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
          searchQuery: @state.searchQuery
          isTableExportedFn: @_isTableExported
          onToggleBucketFn: @_handleToggleBucket
          isBucketToggledFn: @_isBucketToggled


  _renderTableRow: (table) ->
    div className: 'tr',
      span className: 'td',
        table.get 'name'


  _renderHeaderRow: ->
    div className: 'tr',
      span className: 'th',
        strong null, 'Table name'


  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      "SIDE BAR TODO"

  _filterBuckets: (buckets) ->
    result = buckets.filter (bucket) ->
      bucket.get('stage') == 'out'
    console.log result
    result


  _isTableExportedFn: (table) ->
    return false

  _onToggleBucketFn: (bucketId) ->
    return bucketId

  _isBucketToggledFn: (bucketId) ->
    false

  _handleSearchQueryChange: (newQuery) ->
    return newQuery
