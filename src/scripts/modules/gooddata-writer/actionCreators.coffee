
Promise = require 'bluebird'
dispatcher = require '../../Dispatcher'
constants = require './constants'
goodDataWriterStore = require './store'
goodDataWriterApi = require './api'
goodDataWriterConstants = require './constants'

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


  changeTableExportStatus: (configurationId, tableId, newExportStatus) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.GOOD_DATA_WRITER_TABLE_EXPORT_STATUS_CHANGE_START
      configurationId: configurationId
      tableId: tableId
      newExportStatus: newExportStatus

    goodDataWriterApi
    .updateTable(configurationId, tableId,
      export: newExportStatus
    )
    .then ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_TABLE_EXPORT_STATUS_CHANGE_SUCCESS
        configurationId: configurationId
        tableId: tableId
        newExportStatus: newExportStatus
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.GOOD_DATA_WRITER_TABLE_EXPORT_STATUS_CHANGE_ERROR
        configurationId: configurationId
        tableId: tableId
        newExportStatus: newExportStatus
      throw e


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

  saveTableColumnsEdit: (configurationId, tableId) ->

