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
