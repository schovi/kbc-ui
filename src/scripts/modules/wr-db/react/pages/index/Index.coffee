React = require 'react'
{fromJS, Map, List} = require('immutable')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

TableRow = React.createFactory require('./TableRow')
TablesByBucketsPanel = React.createFactory require('../../../../components/react/components/TablesByBucketsPanel')
ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)
SearchRow = require '../../../../../react/common/SearchRow'

LatestJobsStore = require '../../../../jobs/stores/LatestJobsStore'
RoutesStore = require '../../../../../stores/RoutesStore'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
WrDbStore = require '../../../store'
WrDbActions = require '../../../actionCreators'

InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'

componentId = 'wr-db'
driver = 'mysql'


{p, ul, li, span, button, strong, div, i} = React.DOM

module.exports = React.createClass
  displayName: 'wrdbIndex'

  mixins: [createStoreMixin(InstalledComponentsStore, LatestJobsStore, WrDbStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    toggles = localState.get('bucketToggles', Map())

    tables = WrDbStore.getTables(driver, configId)
    credentials = WrDbStore.getCredentials(driver, configId)
    console.log 'CONFIG tables:', tables.toJS(), 'credentials:', credentials.toJS()

    #state
    tables: tables
    credentials: credentials
    configId: configId
    hasCredentials: true #TODO
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
          componentId: componentId
          configId: @state.configId
      if true or @state.hasCredentials
        React.createElement SearchRow,
          className: 'row kbc-search-row'
          onChange: @_handleSearchQueryChange
          query: @state.localState.get('searchQuery')
      if @state.hasCredentials
        TablesByBucketsPanel
          renderTableRowFn: @_renderTableRow
          renderHeaderRowFn: @_renderHeaderRow
          filterFn: @_filterBuckets
          searchQuery: @state.localState.get('searchQuery')
          isTableExportedFn: @_isTableExported
          onToggleBucketFn: @_handleToggleBucket
          isBucketToggledFn: @_isBucketToggled
      else
        div className: 'row component-empty-state text-center',
          div null,
            p null, 'No credentials provided.'
            span className: 'btn btn-success',
              i className: 'fa fa-fw fa-dropbox'
              ' Setup Credentials'

  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      div className: 'kbc-buttons kbc-text-light',
        span null,
          'TODO '


  _renderTableRow: (table) ->
    #div null, table.get('id')
    TableRow
      isTableExported: @_isTableExported(table.get('id'))
      isPending: @_isPendingTable(table.get('id'))
      onExportChangeFn: =>
        @_handleExportChange(table.get('id'))
      table: table
      prepareSingleUploadDataFn: @_prepareTableUploadData

  _renderHeaderRow: ->
    div className: 'tr',
      span className: 'th',
        strong null, 'Table name'
      span className: 'th',
        strong null, 'Destination Table name'

  _handleExportChange: (tableId) ->

  _isPendingTable: (tableId) ->
    return false

  _prepareTableUploadData: (table) ->
    return []

  _isTableExported: (tableId) ->
    table = @_getConfigTable(tableId)
    return table and table.get('export')
    # intables = @_getInputTables()
    # !!intables.find((table) ->
    #   table.get('source') == tableId)


  _filterBuckets: (buckets) ->
    buckets = buckets.filter (bucket) ->
      bucket.get('stage') == 'out'
    return buckets

  _handleToggleBucket: (bucketId) ->
    newValue = !@_isBucketToggled(bucketId)
    newToggles = @state.bucketToggles.set(bucketId, newValue)
    @_updateLocalState(['bucketToggles'], newToggles)

  _isBucketToggled: (bucketId) ->
    !!@state.bucketToggles.get(bucketId)


  _handleSearchQueryChange: (newQuery) ->
    @_updateLocalState(['searchQuery'], newQuery)

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)

  _getConfigTable: (tableId) ->
    @state.tables.find( (table) ->
      tableId == table.get 'id')
