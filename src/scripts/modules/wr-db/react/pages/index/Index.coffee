React = require 'react'
{fromJS, Map, List} = require('immutable')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))
Link = React.createFactory(require('react-router').Link)
TableRow = React.createFactory require('./TableRow')
TablesByBucketsPanel = React.createFactory require('../../../../components/react/components/TablesByBucketsPanel')
ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'
SearchRow = require '../../../../../react/common/SearchRow'

LatestJobsStore = require '../../../../jobs/stores/LatestJobsStore'
RoutesStore = require '../../../../../stores/RoutesStore'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
WrDbStore = require '../../../store'
WrDbActions = require '../../../actionCreators'
DeleteConfigurationButton = require '../../../../components/react/components/DeleteConfigurationButton'
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

    tables = WrDbStore.getTables(componentId, configId)
    credentials = WrDbStore.getCredentials(componentId, configId)
    console.log 'CONFIG tables:', tables.toJS(), 'credentials:', credentials.toJS()

    #state
    updatingTables: WrDbStore.getUpdatingTables(componentId, configId)
    tables: tables
    credentials: credentials
    configId: configId
    hasCredentials: WrDbStore.hasCredentials(componentId, configId)
    localState: localState
    bucketToggles: toggles


  render: ->
    console.log 'render'
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
          query: @state.localState.get('searchQuery') or ''
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
        React.createElement ComponentMetadata,
          componentId: componentId
          configId: @state.configId

      ul className: 'nav nav-stacked',
        li null,
          Link
            to: 'wr-db-credentials'
            params:
              config: @state.configId
          ,
            i className: 'fa fa-fw fa-user'
            ' Database Credentials'
        li null,
          RunButtonModal
            title: "Upload tables"
            tooltip: "Upload all selected tables"
            mode: 'link'
            icon: 'fa fa-upload fa-fw'
            component: 'wr-db'
            runParams: =>
              writer: @props.configId
          ,
           "You are about to run upload of all seleted tables"
        li null,
          React.createElement DeleteConfigurationButton,
            componentId: componentId
            configId: @state.configId


  _renderTableRow: (table) ->
    #div null, table.get('id')
    TableRow
      configId: @state.configId
      tableDbName: @_getConfigTable(table.get('id')).get('name')
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
        strong null, 'Database name'

  _handleExportChange: (tableId) ->
    isExported = @_isTableExported(tableId)
    newExportedValue = !isExported
    table = @_getConfigTable(tableId)
    dbName = tableId
    if table and table.get('name')
      dbName = table.get('name')
    WrDbActions.setTableToExport(componentId, @state.configId, tableId, dbName, newExportedValue)

  _isPendingTable: (tableId) ->
    return @state.updatingTables.has(tableId)

  _prepareTableUploadData: (table) ->
    return []

  _isTableExported: (tableId) ->
    table = @_getConfigTable(tableId)
    table and (table.get('export') == true)

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
      tableId == table.get('id')
    )
