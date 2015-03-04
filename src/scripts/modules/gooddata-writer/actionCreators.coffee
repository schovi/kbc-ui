
Promise = require 'bluebird'
dispatcher = require '../../Dispatcher'
constants = require './constants'
goodDataWriterStore = require './store'
goodDataWriterApi = require './api'
goodDataWriterConstants = require './constants'

dimensionsStore = require './dateDimensionsStore'

module.exports =

  loadConfigurationForce: (configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_START
      configurationId: configurationId

    Promise.props
      id: configurationId
      writer: goodDataWriterApi.getWriter(configurationId)
      tables: goodDataWriterApi.getWriterTables(configurationId)
    .then (configuration) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_SUCCESS
        configuration: configuration

    .catch (error) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_ERROR
        configurationId: configurationId
      throw error

  loadConfiguration: (configurationId) ->
    return Promise.resolve() if goodDataWriterStore.hasWriter(configurationId)
    @loadConfigurationForce(configurationId)

  loadTableDetailForce: (configurationId, tableId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_TABLE_START
      configurationId: configurationId

    goodDataWriterApi.getTableDetail(configurationId, tableId)
    .then (table) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_TABLE_SUCCESS
        configurationId: configurationId
        table: table
    .catch (error) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_TABLE_ERROR
        configurationId: configurationId
        tableId: tableId
      throw error

  loadTableDetail: (configurationId, tableId) ->
    return Promise.resolve() if goodDataWriterStore.hasTableColumns(configurationId, tableId)
    @loadTableDetailForce(configurationId, tableId)

  loadReferencableTablesForce: (configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_REFERENCABLE_TABLES_START
      configurationId: configurationId

    goodDataWriterApi.getReferenceableTables(configurationId)
    .then (tables) ->
      console.log 'tables', tables
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_REFERENCABLE_TABLES_SUCCESS
        configurationId: configurationId
        tables: tables
    .catch (error) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_REFERENCABLE_TABLES_ERROR
        configurationId: configurationId
        error: e
      throw error

  loadReferenceableTables: (configurationId) ->
    @loadReferencableTablesForce(configurationId)

  saveTableField: (configurationId, tableId, fieldName, newValue) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_SAVE_TABLE_FIELD_START
      configurationId: configurationId
      tableId: tableId
      field: fieldName
      value: newValue

    data = {}
    data[fieldName] = newValue
    goodDataWriterApi
    .updateTable(configurationId, tableId, data)
    .then ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_SAVE_TABLE_FIELD_SUCCESS
        configurationId: configurationId
        tableId: tableId
        field: fieldName
        value: newValue
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_SAVE_TABLE_FIELD_ERROR
        configurationId: configurationId
        tableId: tableId
        field: fieldName
        value: newValue
      throw e

  startTableFieldEdit: (configurationId, tableId, field) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_TABLE_FIELD_EDIT_START
      tableId: tableId
      configurationId: configurationId
      field: field

  updateTableFieldEdit: (configurationId, tableId, field, newValue) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_TABLE_FIELD_EDIT_UPDATE
      configurationId: configurationId
      tableId: tableId
      field: field
      value: newValue

  cancelTableFieldEdit: (configurationId, tableId, field) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_TABLE_FIELD_EDIT_CANCEL
      tableId: tableId
      configurationId: configurationId
      field: field


  startTableColumnsEdit: (configurationId, tableId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_START
      configurationId: configurationId
      tableId: tableId

  cancelTableColumnsEdit: (configurationId, tableId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_CANCEL
      configurationId: configurationId
      tableId: tableId

  updateTableColumnsEdit: (configurationId, tableId, column) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_UPDATE
      configurationId: configurationId
      tableId: tableId
      column: column

  saveTableColumnsEdit: (configurationId, tableId) ->
    columns = goodDataWriterStore.getTableColumns(configurationId, tableId, 'editing')

    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_SAVE_START
      configurationId: configurationId
      tableId: tableId

    goodDataWriterApi
    .updateTable(configurationId, tableId,
      columns: columns.toJS()
    )
    .then ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_SAVE_SUCCESS
        configurationId: configurationId
        tableId: tableId
        columns: columns.toJS()

    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_SAVE_ERROR
        configurationId: configurationId
        tableId: tableId
        error: e
      throw e


  loadDateDimensions: (configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_DATE_DIMENSIONS_START
      configurationId: configurationId

    goodDataWriterApi
    .getDateDimensions(configurationId)
    .then (dimensions) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_DATE_DIMENSIONS_SUCCESS
        configurationId: configurationId
        dimensions: dimensions
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_LOAD_DATE_DIMENSIONS_ERROR
        configurationId: configurationId
        error: e
      throw e

  deleteDateDimension: (configurationId, dateDimensionName) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_DATE_DIMENSION_DELETE_START
      configurationId: configurationId
      dimensionName: dateDimensionName

    goodDataWriterApi
    .deleteDateDimension(configurationId, dateDimensionName)
    .then ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_DATE_DIMENSION_DELETE_SUCCESS
        configurationId: configurationId
        dimensionName: dateDimensionName
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_DATE_DIMENSION_DELETE_ERROR
        configurationId: configurationId
        dimensionName: dateDimensionName
        error: e
      throw e


  updateNewDateDimension: (configurationId, newDimension) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_NEW_DATE_DIMENSION_UPDATE
      configurationId: configurationId
      dimension: newDimension

  saveNewDateDimension: (configurationId) ->
    dateDimension = dimensionsStore.getNewDimension(configurationId)

    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_NEW_DATE_DIMENSION_SAVE_START
      configurationId: configurationId

    goodDataWriterApi
    .createDateDimension(configurationId, dateDimension.toJS())
    .then ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_NEW_DATE_DIMENSION_SAVE_SUCCESS
        configurationId: configurationId
        dimension: dateDimension
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_NEW_DATE_DIMENSION_SAVE_ERROR
        configurationId: configurationId
        error: e
      throw e