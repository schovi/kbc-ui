React = require 'react'
storageTablesStore = require '../../stores/StorageTablesStore'
storageActionCreators = require '../../StorageActionCreators'
Loader = React.createFactory(require('kbc-react-components').Loader)
Select = React.createFactory(require('react-select'))
createStoreMixin = require '../../../../react/mixins/createStoreMixin'

module.exports = React.createClass
  displayNanme: 'SapiTableSelector'

  mixins: [createStoreMixin(storageTablesStore)]
  propTypes:
    onSelectTableFn: React.PropTypes.func.isRequired
    placeholder: React.PropTypes.string.isRequired
    value: React.PropTypes.string.isRequired
    excludeTableFn: React.PropTypes.func.isRequired


  getStateFromStores: ->
    isTablesLoading = storageTablesStore.getIsLoading()
    tables = storageTablesStore.getAll()

    #state
    isTablesLoading: isTablesLoading
    tables: tables

  componentDidMount: ->
    storageActionCreators.loadTables()


  render: ->
    isTablesLoading = @state.isTablesLoading
    if isTablesLoading
      return Loader()

    Select
      name: 'source'
      value: @props.value
      placeholder: @props.placeholder
      onChange: @props.onSelectTableFn
      options: @_getTables()

  _getTables: ->
    tables = @state.tables
    tables = tables.filter (table) =>
      stage = table.get('bucket').get('stage')
      stage in ['in','out'] and not @props.excludeTableFn(table.get('id'))
    tables = tables.map (table) ->
      tableId = table.get 'id'
      {
        label: tableId
        value: tableId
      }
    tables.toList().toJS()
