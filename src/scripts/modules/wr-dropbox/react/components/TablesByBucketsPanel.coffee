React = require 'react'
fuzzy = require 'fuzzy'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ActiveCountBadge = require './ActiveCountBadge'
storageTablesStore = require '../../../components/stores/StorageTablesStore'
storageActionCreators = require '../../../components/StorageActionCreators'
{strong, br, ul, li, div, span, i, a, button, p} = React.DOM
{Panel, PanelGroup, Alert, DropdownButton} = require('react-bootstrap')

module.exports = React.createClass

  displayName: 'tablesByBucketsPanel'

  mixins: [createStoreMixin(storageTablesStore)]

  propTypes:
    renderTableRowFn: React.PropTypes.func.isRequired
    renderHeaderRowFn: React.PropTypes.func
    filterFn: React.PropTypes.func
    searchQuery: React.PropTypes.string #used as filter of tables
    isTableExportedFn: React.PropTypes.func
    onToggleBucketFn: React.PropTypes.func
    isBucketToggledFn: React.PropTypes.func

  getStateFromStores: ->
    {}

  componentDidMount: ->
    storageActionCreators.loadTables()

  render: ->
    isTablesLoading = storageTablesStore.getIsLoading()
    buckets = @_getFilteredBuckets()
    if isTablesLoading
      div className: 'well',
        'Loading Tables...'
    else
      if buckets.count()
        div
          className: 'kbc-accordion kbc-panel-heading-with-table kbc-panel-heading-with-table'
        ,
          buckets.map (bucket, bucketId) ->
            @_renderBucketPanel bucketId, bucket.get 'tables'
          , @
          .toArray()
      else
        @_renderNotFound()


  _renderBucketPanel: (bucketId, tables) ->
    activeCount = 0
    if @props.isTableExportedFn
      activeCount = tables.filter((table) =>
        @props.isTableExportedFn(table.get('id'))
        ).count()
    header = span null,
      span className: 'table',
        span className: 'tbody',
          span className: 'tr',
            span className: 'td',
              bucketId
            if @props.isTableExportedFn
              span className: 'td text-right',
                React.createElement ActiveCountBadge,
                  totalCount: tables.size
                  activeCount: activeCount

    React.createElement Panel,
      header: header
      key: bucketId
      eventKey: bucketId
      expanded: !!@props.searchQuery?.length || @_isBucketToggled(bucketId)
      collapsible: true
      onSelect: @_handleBucketSelect.bind(@, bucketId)
    ,
      @_renderTablesList(tables)

  _renderTablesList: (tables) ->
    childs = tables.map((table) =>
      @props.renderTableRowFn(table)
    , @).toArray()

    header = @_renderDefaultHeaderRow()
    if @props.renderHeaderRowFn
      header = @props.renderHeaderRowFn(tables)

    div className: 'row',
      div className: 'table table-striped table-hover',
        if header
          div className: 'thead', key: 'table-header',
            header
        div className: 'tbody',
          childs

  _renderDefaultHeaderRow: ->
    div className: 'tr',
      span className: 'th',
        strong null, 'Table name'



  _getTablesByBucketsList: (tables) ->
    groupedBuckets = tables.groupBy (value, key) ->
      value.getIn ['bucket','id']

    buckets = groupedBuckets.map( (bucketTables) ->
      firstTable = bucketTables.first()
      bucket = firstTable.get 'bucket'
      bucket.set('tables', bucketTables.toList())
    ).mapKeys((key, bucket) ->
      bucket.get 'id'
    )

    return buckets

  _isBucketToggled: (bucketId) ->
    togled = @props.isBucketToggledFn(bucketId)
    return togled

  _handleBucketSelect: (bucketId, e) ->
    e.preventDefault()
    e.stopPropagation()
    @props.onToggleBucketFn bucketId

  _renderNotFound: ->
    div {className: 'table table-striped'},
      div {className: 'tfoot'},
        div {className: 'tr'},
          div {className: 'td'}, 'No tables found'

  #load buckets and tables from storage store and filter them
  _getFilteredBuckets: ->
    tables = storageTablesStore.getAll()
    buckets = @_getTablesByBucketsList(tables)
    if @props.filterFn
      filteredBuckets = @props.filterFn(buckets)
    else
      filteredBuckets =  buckets
    #filter according to search query
    filteredBuckets = filteredBuckets.map (bucketObject, bucketId) =>
      bucketObject.set('tables', @_filterBucketTables(bucketObject))
    filteredBuckets = filteredBuckets.filter (bucket) ->
      bucket.get('tables').count() > 0
    return filteredBuckets

  _filterBucketTables: (bucket) ->
    query = @props.searchQuery
    tables = bucket.get('tables')
    if not query
      return tables
    newTables = tables.filter( (table) ->
      tableId = table.get('id')
      fuzzy.match(query, tableId)
    )
    return newTables
