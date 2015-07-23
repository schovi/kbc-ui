Promise = require('bluebird')
api = require('./api')
store = require('./store')
dispatcher = require('../../Dispatcher')
constants = require './constants'
provisioningUtils = require './provisioningUtils'
{fromJS} = require 'immutable'
driver = 'mysql'

convertFromProvCredentials = (creds) ->
  host: creds.get 'hostname'
  database: creds.get 'db'
  port: "3306" #todo1!
  password: creds.get 'password'
  user: creds.get 'user'
  driver: driver

module.exports =
  loadProvisioningCredentials: (componentId, configId, isReadOnly) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_LOAD_PROVISIONING_START
      componentId: componentId
      configId: configId
    provisioningUtils.getCredentials(isReadOnly).then (result) =>
      if isReadOnly
        dispatcher.handleViewAction
          type: constants.ActionTypes.WR_DB_LOAD_PROVISIONING_SUCCESS
          componentId: componentId
          configId: configId
          credentials: result
      else
        writeCreds = fromJS(convertFromProvCredentials(result.write))
        @saveCredentials(componentId, configId, writeCreds).then ->
          dispatcher.handleViewAction
            type: constants.ActionTypes.WR_DB_LOAD_PROVISIONING_SUCCESS
            componentId: componentId
            configId: configId
            credentials: result

    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        componentId: componentId
        configId: configId
        error: err
      throw err


  loadTableConfig: (componentId, configId, tableId) ->
    if store.hasTableConfig(componentId, configId, tableId)
      return Promise.resolve()
    else
      @loadTableConfigForce(componentId, configId, tableId)

  loadTableConfigForce: (componentId, configId, tableId) ->
    api.getTable(configId, tableId)
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_GET_TABLE_SUCCESS
        componentId: componentId
        configId: configId
        tableId: tableId
        tableConfig: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        componentId: componentId
        configId: configId
        error: err
      throw err

  resetCredentials: (componentId, configId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_SAVE_CREDENTIALS_SUCCESS
      componentId: componentId
      configId: configId
      credentials: null

  setEditingData: (componentId, configId, path, data) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_SET_EDITING
      componentId: componentId
      configId: configId
      path: path
      data: data

  saveCredentials: (componentId, configId, credentials) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_SAVE_CREDENTIALS_START
      componentId: componentId
      configId: configId
      credentials: credentials
    api.postCredentials(configId, credentials.toJS())
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_SAVE_CREDENTIALS_SUCCESS
        componentId: componentId
        configId: configId
        credentials: credentials

    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        componentId: componentId
        configId: configId
        errorPath: ['savingCredentials', componentId, configId]
        error: err
      throw err

  loadConfiguration: (componentId, configId) ->
    if store.hasConfiguration(componentId, configId)
      return Promise.resolve()
    else
      @loadConfigurationForce(componentId, configId)


  loadConfigurationForce: (componentId, configId) ->
    Promise.props
      componentId: componentId
      configId: configId
      credentials: api.getCredentials(configId)
      tables: api.getTables(configId)
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_GET_CONFIGURATION_SUCCESS
        componentId: componentId
        configId: configId
        config: result #credentials&tables
    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        componentId: componentId
        configId: configId
        error: err
      throw err

  saveTableColumns: (componentId, configId, tableId, columns) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_SAVE_COLUMNS_START
      componentId: componentId
      configId: configId
      tableId: tableId
      columns: columns

    api.setTableColumns(configId, tableId, columns.toJS())
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_SAVE_COLUMNS_SUCCESS
        componentId: componentId
        configId: configId
        tableId: tableId
        columns: columns

    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        componentId: componentId
        configId: configId
        error: err
      throw err


  setTableToExport: (componentId, configId, tableId, dbName, isExported) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.WR_DB_SET_TABLE_START
      componentId: componentId
      configId: configId
      tableId: tableId
      dbName: dbName
      isExported: isExported
    api.setTable(configId, tableId, dbName, isExported)
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_SET_TABLE_SUCCESS
        componentId: componentId
        configId: configId
        tableId: tableId
        dbName: dbName
        isExported: isExported
    .catch (err) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.WR_DB_API_ERROR
        componentId: componentId
        configId: configId
        error: err
      throw err
