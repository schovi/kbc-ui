React = require 'react'
storageTablesStore = require '../../stores/StorageTablesStore'
storageActionCreators = require '../../StorageActionCreators'
Loader = React.createFactory(require('kbc-react-components').Loader)
Select = React.createFactory(require('react-select'))
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
validateStorageTableId = require '../../../../utils/validateStorageTableId'

module.exports = React.createClass
  displayNanme: 'SapiTableSelector'

  mixins: [createStoreMixin(storageTablesStore)]
  propTypes:
    onSelectTableFn: React.PropTypes.func.isRequired
    placeholder: React.PropTypes.string.isRequired
    value: React.PropTypes.string.isRequired
    excludeTableFn: React.PropTypes.func
    allowedBuckets: React.PropTypes.array
    allowCreate: React.PropTypes.bool

  getDefaultProps: ->
    excludeTableFn: (tableId) ->
      return false
    allowedBuckets: ['in','out']
    allowCreate: false

  getStateFromStores: ->
    isTablesLoading = storageTablesStore.getIsLoading()
    tables = storageTablesStore.getAll()

    #state
    isTablesLoading: isTablesLoading
    tables: tables

  componentDidMount: ->
    setTimeout ->
      storageActionCreators.loadTables()

  shouldComponentUpdate: (nextProps, nextState) ->
    nextProps.value != @props.value || nextState.isTablesLoading != @state.isTablesLoading

  render: ->
    isTablesLoading = @state.isTablesLoading
    if isTablesLoading
      return React.DOM.div null,
        Loader()
        ' Loading tables...'

    Select
      name: 'source'
      clearable: @props.allowCreate
      allowCreate: @props.allowCreate
      value: @props.value
      placeholder: @props.placeholder
      onChange: (tableId) =>
        table = @state.tables.find (t) ->
          t.get('id') == tableId
        @props.onSelectTableFn(tableId, table)
      options: @_getTables()
      newOptionCreator: @_newOptionCreator

  _getTables: ->
    tables = @state.tables
    tables = tables.filter (table) =>
      stage = table.get('bucket').get('stage')
      excludeTable = @props.excludeTableFn(table.get('id'), table)
      (stage in @props.allowedBuckets) and not excludeTable
    tables = tables.sort (a, b) ->
      a.get('id').localeCompare(b.get('id'))
    tables = tables.map (table) ->
      tableId = table.get 'id'
      {
        label: tableId
        value: tableId
      }
    tables.toList().toJS()

  _newOptionCreator: (value) ->
    create = false
    label = value
    if (validateStorageTableId(value))
      create = true
    else
      label = value + ' is not a valid table identifier'
    return {
      value: value
      label: label
      create: create
    }
    return false
