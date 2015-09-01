React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'

goodDataWriterStore = require '../../../store'
actionCreators = require '../../../actionCreators'
storageApi = require '../../../../components/StorageApi'

{strong, br, ul, li, div, span, i, p} = React.DOM

ColumnsEditor = React.createFactory(require './DatasetColumnsEditor')
EditButtons = React.createFactory(require('../../../../../react/common/EditButtons'))
TableGdName = React.createFactory(require './TableGdNameEdit')

module.exports = React.createClass
  displayName: 'GooddDataWriterTable'
  mixins: [createStoreMixin(goodDataWriterStore)]

  getStateFromStores: ->
    configurationId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('table')
    isEditingColumns = goodDataWriterStore.isEditingTableColumns(configurationId, tableId)

    configurationId: configurationId
    table: goodDataWriterStore.getTable(configurationId, tableId)
    isEditingColumns: isEditingColumns
    isSavingColumns: goodDataWriterStore.isSavingTableColumns(configurationId, tableId)
    referenceableTables: goodDataWriterStore.getReferenceableTablesForTable(configurationId, tableId)
    invalidColumns: goodDataWriterStore.getTableColumnsValidation(configurationId, tableId)
    showIdentifier: goodDataWriterStore.isNewWriter(configurationId)
    columnsReferences: goodDataWriterStore.getTableColumnsReferences(configurationId, tableId)
    columns: goodDataWriterStore.getTableColumns(configurationId,
      tableId,
      if isEditingColumns then 'editing' else 'current'
    )

  getInitialState: ->
    dataPreview: null

  componentDidMount: ->
    component = @
    storageApi
    .exportTable @state.table.get('id'),
      limit: 10
    .then (csv) ->
      component.setState
        dataPreview: csv

  _handleEditStart: ->
    actionCreators.startTableColumnsEdit(@state.configurationId, @state.table.get 'id')

  _handleEditSave: ->
    actionCreators.saveTableColumnsEdit(@state.configurationId, @state.table.get 'id')

  _handleEditCancel: ->
    actionCreators.cancelTableColumnsEdit(@state.configurationId, @state.table.get 'id')

  _handleEditUpdate: (column) ->
    actionCreators.updateTableColumnsEdit(@state.configurationId, @state.table.get('id'), column)

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-header',
        p className: '',
          strong null, 'GoodData Name'
          ' '
          TableGdName
            table: @state.table
            configurationId: @state.configurationId
            fieldName: 'title'
            placeholder: 'Table Name'
          ' '
        if @state.showIdentifier
          p className: '',
            strong null, 'GoodData Identifier'
            ' '
            TableGdName
              table: @state.table
              configurationId: @state.configurationId
              fieldName: 'identifier'
            ' '
        div className: 'kbc-buttons',
          EditButtons
            isEditing: @state.isEditingColumns
            isSaving: @state.isSavingColumns
            isDisabled: @state.invalidColumns.count() > 0
            onCancel: @_handleEditCancel
            onSave: @_handleEditSave
            onEditStart: @_handleEditStart
            editLabel: 'Edit Columns'

      ColumnsEditor
        columns: @state.columns
        invalidColumns: @state.invalidColumns
        columnsReferences: @state.columnsReferences
        referenceableTables: @state.referenceableTables
        showIdentifier: @state.showIdentifier
        isEditing: @state.isEditingColumns
        isSaving: @state.isSavingColumns
        onColumnChange: @_handleEditUpdate
        configurationId: @state.configurationId
        dataPreview: @state.dataPreview
