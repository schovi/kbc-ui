React = require 'react'
{ListGroup, ListGroupItem, OverlayTrigger, Tooltip} = require 'react-bootstrap'
Popover = React.createFactory(require('react-bootstrap').Popover)


filesize = require 'filesize'

date = require '../../../../utils/date'
storageTablesStore = require '../../../components/stores/StorageTablesStore'
storageActionCreators = require '../../../components/StorageActionCreators'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ApplicationStore = require '../../../../stores/ApplicationStore'
PureRenderMixin = require '../../../../react/mixins/ImmutableRendererMixin'

{button, i,a, strong, span, div, p, ul, li} = React.DOM

module.exports = React.createClass
  displayName: 'StorageApiTableLinkEx'
  propTypes:
    tableId: React.PropTypes.string
    children: React.PropTypes.any
    placement: React.PropTypes.string

  getDefaultProps: ->
    placement: 'bottom'

  mixins: [createStoreMixin(storageTablesStore), PureRenderMixin]

  getStateFromStores: ->
    isTablesLoading = storageTablesStore.getIsLoading()
    tables = storageTablesStore.getAll()

    table = null
    if tables
      table = tables.get @props.tableId
      console.log table.toJS()

    #state
    isTablesLoading: isTablesLoading
    table: table

  componentDidMount: ->
    storageActionCreators.loadTables()

  render: ->
    if not @state.table
      span null, @props.tableId
    else
      span null,
        @_renderTableWithTooltipInfo()
        #@_renderTableWithPopoverInfo()

  _renderTableWithPopoverInfo: ->
    span null,
      @_renderTableUrl()
      React.createElement OverlayTrigger,
        placement: @props.placement
        overlay: @_renderPopover()
        trigger: 'click'
        rootClose: true
      ,
        React.DOM.button className: 'btn btn-link',
          React.DOM.span className: 'fa fa-eye'

  _renderPopover: ->
    Popover
      style: {maxWidth: "350px"}
      title: "#{@props.tableId}"
    ,
      ul null,
        @_renderTableRow 'Created', date.format @state.table.get('created')
        @_renderTableRow 'Last Import', date.format @state.table.get('lastImportDate')
        @_renderTableRow 'Last Change', date.format @state.table.get('lastChangeDate')
        @_renderTableRow 'Rows count', "#{@state.table.get('rowsCount')} rows"
        @_renderTableRow 'Data size', filesize(@state.table.get('dataSizeBytes'))
        @_renderTableRow 'Columns', (@state.table.get('columns')?.toJS().join(', '))



  _renderTableRow: (label, value) ->
    console.log "redener row ", label, value
    li null,
      "#{label}: #{value}"


  _renderTableWithTooltipInfo: ->
    React.createElement OverlayTrigger,
      overlay: @_renderTooltip()
      placement: 'top'
    ,
      @_renderTableUrl()

  _renderTableUrl: ->
    a href: @_tableUrl(),
      @props.children or @props.tableId

  _renderTooltip: ->
    React.createElement Tooltip,
      null
    ,
      div null, date.format @state.table.get('lastChangeDate')
      div null, filesize(@state.table.get('dataSizeBytes'))
      div null, "#{@state.table.get('rowsCount')} rows"


  _tableUrl: ->
    return ApplicationStore.getSapiTableUrl(@props.tableId)
