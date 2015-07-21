Promise = require('bluebird')
api = require('./api')
store = require('./store')
dispatcher = require('../../Dispatcher')
constants = require './constants'
provisioningUtils = require './provisioningUtils'

driver = 'mysql'

module.exports =
  loadProvisioningCredentials: (driver, configId, isReadOnly) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_LOAD_PROVISIONING_START
      driver: driver
      configId: configId
    provisioningUtils.getCredentials(isReadOnly).then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_LOAD_PROVISIONING_SUCCESS
        driver: driver
        configId: configId
        credentials: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        driver: driver
        configId: configId
        error: err
      throw err


  loadTableConfig: (driver, configId, tableId) ->
    if store.hasTableConfig(driver, configId, tableId)
      return Promise.resolve()
    else
      @loadTableConfigForce(driver, configId, tableId)

  loadTableConfigForce: (driver, configId, tableId) ->
    api.getTable(driver, configId, tableId)
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_GET_TABLE_SUCCESS
        driver: driver
        configId: configId
        tableId: tableId
        tableConfig: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        driver: driver
        configId: configId
        error: err
      throw err

  setEditingData: (driver, configId, path, data) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_SET_EDITING
      driver: driver
      configId: configId
      path: path
      data: data

  saveCredentials: (driver, configId, credentials) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_SAVE_CREDENTIALS_START
      driver: driver
      configId: configId
      credentials: credentials
    api.postCredentials(driver, configId, credentials.toJS())
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_SAVE_CREDENTIALS_SUCCESS
        driver: driver
        configId: configId
        credentials: credentials

    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        driver: driver
        configId: configId
        errorPath: ['savingCredentials', driver, configId]
        error: err
      throw err

  loadConfiguration: (driver, configId) ->
    if store.hasConfiguration(driver, configId)
      return Promise.resolve()
    else
      @loadConfigurationForce(driver, configId)


  loadConfigurationForce: (driver, configId) ->
    Promise.props
      driver: driver
      configId: configId
      credentials: api.getCredentials(driver, configId)
      tables: api.getTables(driver, configId)
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_GET_CONFIGURATION_SUCCESS
        driver: driver
        configId: configId
        config: result #credentials&tables
    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        driver: driver
        configId: configId
        error: err
      throw err

  saveTableColumns: (driver, configId, tableId, columns) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_SAVE_COLUMNS_START
      driver: driver
      configId: configId
      tableId: tableId
      columns: columns

    api.setTableColumns(driver, configId, tableId, columns.toJS())
    .then (result) ->
      console.log "SET COLUMNS API RESULT", result
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_SAVE_COLUMNS_SUCCESS
        driver: driver
        configId: configId
        tableId: tableId
        columns: columns

    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        driver: driver
        configId: configId
        error: err
      throw err


  setTableToExport: (driver, configId, tableId, dbName, isExported) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_SET_TABLE_START
      driver: driver
      configId: configId
      tableId: tableId
      dbName: dbName
      isExported: isExported
    api.setTable(driver, configId, tableId, dbName, isExported)
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_SET_TABLE_SUCCESS
        driver: driver
        configId: configId
        tableId: tableId
        dbName: dbName
        isExported: isExported
    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        driver: driver
        configId: configId
        error: err
      throw err
