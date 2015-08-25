React = require 'react'
{OverlayTrigger, Tooltip} = require 'react-bootstrap'
filesize = require 'filesize'

date = require '../../../../utils/date'
storageTablesStore = require '../../../components/stores/StorageTablesStore'
storageActionCreators = require '../../../components/StorageActionCreators'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ApplicationStore = require '../../../../stores/ApplicationStore'

{button, i,a, strong, span, div, p, ul, li} = React.DOM

module.exports = React.createClass
  displayName: 'StorageApiTableLinkEx'
  propTypes:
    tableId: React.PropTypes.string
    children: React.PropTypes.any

  mixins: [createStoreMixin(storageTablesStore)]

  getStateFromStores: ->
    isTablesLoading = storageTablesStore.getIsLoading()
    tables = storageTablesStore.getAll()

    table = null
    if tables
      table = tables.get @props.tableId

    #state
    isTablesLoading: isTablesLoading
    table: table

  componentDidMount: ->
    storageActionCreators.loadTables()

  render: ->
    if not @state.table
      span null, @props.tableId
    else
      @_renderTableWithInfo()


  _renderTableWithInfo: ->
    React.createElement OverlayTrigger,
      overlay: React.createElement Tooltip,
        null
      ,
        div null, date.format @state.table.get('lastChangeDate')
        div null, filesize(@state.table.get('dataSizeBytes'))
        div null, "#{@state.table.get('rowsCount')} rows"

      placement: 'top'
    ,
      a href: @_tableUrl(),
        @props.children or @props.tableId


  _tableUrl: ->
    return ApplicationStore.getSapiTableUrl(@props.tableId)
