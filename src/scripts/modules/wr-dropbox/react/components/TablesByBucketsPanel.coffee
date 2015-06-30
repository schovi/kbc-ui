React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ActiveCountBadge = require './ActiveCountBadge'
SearchRow = require '../../../../react/common/SearchRow'
storageTablesStore = require '../../../components/stores/StorageTablesStore'
storageActionCreators = require '../../../components/StorageActionCreators'
{strong, br, ul, li, div, span, i, a, button, p} = React.DOM
{Panel, PanelGroup, Alert, DropdownButton} = require('react-bootstrap')

module.exports = React.createClass

  displayName: 'tablesByBucketsPanel'

  propTypes:
    renderTableRowFn: React.PropTypes.func.isRequired
    renderHeaderRowFn: React.PropTypes.func
    filterFn: React.PropTypes.func
    onSearchQueryChange: React.PropTypes.func
    searchQuery: React.PropTypes.string
    isTableExportedFn: React.PropTypes.func
    onToggleBucketFn: React.PropTypes.func
    isBucketToggledFn: React.PropTypes.func

  getStateFromStores: ->
    tables = storageTablesStore.getAll()
    buckets = @_getTablesByBucketsList(tables)
    filteredBuckets = if @props.filterFn then @props.filterFn(buckets) else buckets
    #state =
    buckets: filteredBuckets

  mixins: [createStoreMixin(storageTablesStore)]

  componentDidMount: ->
    storageActionCreators.loadTables()

  render: ->
    div null,
      React.createElement SearchRow,
        className: 'row kbc-search-row'
        onChange: @props.onSearchQueryChange
        query: @props.searchQuery
      if @state.buckets.count()
        div
          className: 'kbc-accordion kbc-panel-heading-with-table kbc-panel-heading-with-table'
        ,
          @state.buckets.map (bucket, bucketId) ->
            @_renderBucketPanel bucketId, bucket.get 'tables'
          , @
          .toArray()
      else
        @_renderNotFound()


  _renderBucketPanel: (bucketId, tables) ->
    activeCount = tables.filter((table) =>
      @props.isTableExportedFn?.call(table)
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

    header = @props.renderHeaderRowFn?.call(tables) or @_renderDefaultHeaderRow()

    div className: 'row',
      div className: 'table table-striped table-hover',
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

    console.log "grouped", buckets.toJS()
    return buckets

  _isBucketToggled: (bucketId) ->
    if not @props.isBucketToggledFn
      return false
    return @props.isBucketToggledFn(bucketId)

  _handleBucketSelect: (bucketId, e) ->
    e.preventDefault()
    e.stopPropagation()
    @props.onToggleBucketFn?.call bucketId

  _renderNotFound: ->
    div {className: 'table table-striped'},
      div {className: 'tfoot'},
        div {className: 'tr'},
          div {className: 'td'}, 'No tables found'
