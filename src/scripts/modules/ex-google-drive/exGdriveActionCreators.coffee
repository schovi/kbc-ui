dispatcher = require '../../Dispatcher.coffee'
constants = require './exGdriveConstants.coffee'
Promise = require('bluebird')
exGdriveApi = require './exGdriveApi.coffee'
exGdriveStore = require './exGdriveStore.coffee'
module.exports =

  loadConfigurationForce: (configurationId) ->
    Promise.props
      id: configurationId
      configuration: exGdriveApi.getConfiguration(configurationId)
    .then (configuration) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_GDRIVE_CONFIGURATION_LOAD_SUCCESS
        configuration: configuration

  loadConfiguration: (configurationId) ->
    return Promise.resolve() if exGdriveStore.hasConfig configurationId
    @loadConfigurationForce(configurationId)

  editSheetStart: (configId, fileId, sheetId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_START
      configurationId: configId
      sheetId: sheetId
      fileId: fileId

  cancelSheetEdit: (configId, fileId, sheetId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_CANCEL
      configurationId: configId
      sheetId: sheetId
      fileId: fileId

  sheetEditOnChange: (configId, fileId, sheetId, propName, newValue) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_SHEET_ON_CHANGE
      configurationId: configId
      sheetId: sheetId
      fileId: fileId
      propName: propName
      newValue: newValue

  saveSheetEdit: (configId, fileId, sheetId) ->
    sheetConfig =
      configurationId: configId
      sheetId: sheetId
      fileId: fileId

    #validate sheet before start saving
    sheetConfig.type = constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_VALIDATE
    dispatcher.handleViewAction sheetConfig

    if exGdriveStore.isSheetValid(configId, fileId, sheetId)
      sheetConfig.type = constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_SAVE_START
      dispatcher.handleViewAction sheetConfig #start saving
      sheet = exGdriveStore.getSavingSheet configId, fileId, sheetId
      exGdriveApi.storeNewSheets(configId, [sheet.toJS()])
      .then (result) ->
        sheetConfig.type = constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_SAVE_END
        sheetConfig.result = result
        dispatcher.handleViewAction sheetConfig

  deleteSheet: (configId, fileId, sheetId) ->
    sheetConfig =
      configurationId: configId
      sheetId: sheetId
      fileId: fileId
      type: constants.ActionTypes.EX_GDRIVE_SHEET_DELETE_START
    dispatcher.handleViewAction sheetConfig

    if exGdriveStore.isDeletingSheet configId, fileId, sheetId
      exGdriveApi.deleteSheet(configId, fileId, sheetId).then (result) ->
        sheetConfig.type = constants.ActionTypes.EX_GDRIVE_SHEET_DELETE_END
        dispatcher.handleViewAction sheetConfig
