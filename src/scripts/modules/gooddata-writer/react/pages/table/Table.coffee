React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'

goodDataWriterStore = require '../../../store'
actionCreators = require '../../../actionCreators'

{strong, br, ul, li, div, span, i} = React.DOM

ColumnsEditor = React.createFactory(require './DatasetColumnsEditor')
Button = React.createFactory(require('react-bootstrap').Button)

module.exports = React.createClass
  displayName: 'GooddDataWriterTable'
  mixins: [createStoreMixin(goodDataWriterStore)]

  getStateFromStores: ->
    configurationId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('table')

    configurationId: configurationId
    table: goodDataWriterStore.getTable(configurationId, tableId)
    isEditingColumns: goodDataWriterStore.isEditingTableColumns(configurationId, tableId)
    columns: goodDataWriterStore.getTableColumns(configurationId, tableId)

  _handleEditStart: ->
    actionCreators.startTableColumnsEdit(@state.configurationId, @state.table.get 'id')

  _handleEditSave: ->
    actionCreators.saveTableColumnsEdit(@state.configurationId, @state.table.get 'id')

  _handleEditCancel: ->
    actionCreators.cancelTableColumnsEdit(@state.configurationId, @state.table.get 'id')

  render: ->
    console.log 'render', @state.table.toJS(), @state.columns.toJS()
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-header',
        div className: 'col-sm-8'
        div className: 'col-sm-4 kbc-buttons',
          if @state.isEditingColumns
            span null,
              Button
                bsStyle: 'link'
                onClick: @_handleEditCancel
              ,
                'Cancel'
              Button
                bsStyle: 'success'
                onClick: @_handleEditSave
              ,
                'Save'
          else
            Button
              bsStyle: 'success'
              onClick: @_handleEditStart
            ,
              'Edit columns'

      ColumnsEditor
        columns: @state.columns
        isEditing: @state.isEditingColumns