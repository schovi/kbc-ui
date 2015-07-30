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

  loadFilesForce: (configId) ->
    api.getFiles(configId)
    .then (result) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_LOAD_FILES_SUCCESS
        configId: configId
        files: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_API_ERROR
        configId: configId
        error: err
      throw err

  loadGoogleInfo: (email, googleId) ->

    isLoading = store.getLoadingGoogleInfo(email, googleId)
    console.log "loadGoogleInfo", email, googleId, isLoading
    if !!isLoading
      console.log 'RETUUUURN'
      return

    dispatcher.handleViewAction
      type: ActionTypes.WR_GDRIVE_LOAD_GOOGLEINFO_START
      googleId: googleId
      email: email
    console.log 'DISPATCHER WR_GDRIVE_LOAD_GOOGLEINFO_START'
    api.getFileInfo(googleId).then (result) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_LOAD_GOOGLEINFO_SUCCESS
        info: result
        googleId: googleId
        email: email
    .catch (err) ->
      dispatcher.handleViewAction
        type: ActionTypes.WR_GDRIVE_API_ERROR
        googleId: googleId
        email: email
        error: err
      throw err
