{ActionTypes} = require './constants'
Promise = require('bluebird')
api = require('./api')
dispatcher = require('../../Dispatcher')
{fromJS} = require 'immutable'
store = require './wrGdriveStore'

module.exports =

  loadFiles: (configId) ->
    if store.getFiles(configId)
      return Promise.resolve()
    else
      @loadFilesForce(configId)

  saveFile: (configId, tableId, file) ->
    dispatcher.handleViewAction
      type: ActionTypes.WR_GDRIVE_SAVEFILE_START
      tableId: tableId
      file: file
      configId: configId
    fileId = file?.get 'id'
    if fileId
      apiOperation = api.putFile(configId, fileId, file.toJS())
    else
      apiOperation = api.postFile(configId, file)

    apiOperation.then (result) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_SAVEFILE_SUCCESS
        tableId: tableId
        configId: configId
        files: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_API_ERROR
        configId: configId
        error: err
      throw err

  setGoogleInfo: (configId, googleId, info) ->
    dispatcher.handleViewAction
      type: ActionTypes.WR_GDRIVE_LOAD_GOOGLEINFO_SUCCESS
      googleInfo: info
      googleId: googleId
      configId: configId


  loadFilesForce: (configId) ->
    api.getAccount(configId)
    .then (result) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_LOAD_FILES_SUCCESS
        configId: configId
        files: result.items
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_LOAD_ACCOUNT_SUCCESS
        configId: configId
        account: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_API_ERROR
        configId: configId
        error: err
      throw err

  deleteRow: (configId, rowId, tableId) ->
    dispatcher.handleViewAction
      type: ActionTypes.WR_GDRIVE_DELETE_ROW_START
      configId: configId
      tableId: tableId
    api.deleteFile(configId, rowId).then (result) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_DELETE_ROW_SUCCESS
        configId: configId
        tableId: tableId
    .catch (err) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_API_ERROR
        googleId: googleId
        configId: configId
        error: err
      throw err


  loadGoogleInfo: (configId, googleId) ->
    isLoading = store.getLoadingGoogleInfo(configId, googleId)
    if !!isLoading
      return

    dispatcher.handleViewAction
      type: ActionTypes.WR_GDRIVE_LOAD_GOOGLEINFO_START
      googleId: googleId
      configId: configId
    api.getFileInfo(configId, googleId).then (result) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_LOAD_GOOGLEINFO_SUCCESS
        googleInfo: result
        googleId: googleId
        configId: configId
    .catch (err) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_API_ERROR
        googleId: googleId
        configId: configId
        error: err
      throw err

  setEditingData: (configId, path, data) ->
    dispatcher.handleViewAction
      type: ActionTypes.WR_GDRIVE_SET_EDITING
      configId: configId
      path: path
      data: data
