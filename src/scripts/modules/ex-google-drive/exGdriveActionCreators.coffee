dispatcher = require '../../Dispatcher'
constants = require './exGdriveConstants'
Promise = require('bluebird')
exGdriveApi = require './exGdriveApi'
exGdriveStore = require './exGdriveStore'
module.exports =

  dispatchApiError: (errorPath, error) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_API_ERROR
      errorPath: errorPath


  generateExternalLink: (configId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_GENERATE_EXT_LINK_START
      configurationId: configId
    exGdriveApi.getExtLink(configId).then (extLink) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_GDRIVE_GENERATE_EXT_LINK_END
        configurationId: configId
        extLink: extLink
    .catch (err) =>
      @dispatchApiError(['extLinksGenerating', configId], err)
      throw err

  searchQueryChange: (configId, newValue) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_SEARCH_QUERY_CHANGE
      configurationId: configId
      value: newValue

  saveSheetsSelection: (configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_SAVING_SHEETS_START
      configurationId: configurationId
    sheetsToSave = exGdriveStore.getSavingNewSheets(configurationId)
    exGdriveApi.storeNewSheets(configurationId, sheetsToSave.toArray())
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_GDRIVE_SAVING_SHEETS_SUCCESS
        configurationId: configurationId
        data: result
    .catch (err) =>
      @dispatchApiError( ['savingNewSheets', configurationId], err)
      throw err

  cancelSheetSelection: (configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_SAVING_SHEETS_CANCEL
      configurationId: configurationId

  loadMoreFiles: (configurationId, nextPageToken) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_LOADING_MORE_START
      configurationId: configurationId
      nextPageToken: nextPageToken
    exGdriveApi.getGdriveFiles(configurationId, nextPageToken)
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_GDRIVE_LOADING_MORE_SUCCESS
        configurationId: configurationId
        data: result
        nextPageToken: nextPageToken
    .catch (err) =>
      @dispatchApiError( ['loadingMore', configurationId], err)
      throw err

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

  loadGdriveFiles: (configId, nextPageToken) ->
    return Promise.resolve() if exGdriveStore.hasGdriveFiles configId
    @loadGdriveFilesForce(configId, nextPageToken)

  loadGdriveFilesForce: (configId, nextPageToken) ->
    exGdriveApi.getGdriveFiles(configId, nextPageToken)
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_GDRIVE_FILES_LOAD_SUCCESS
        configurationId: configId
        data: result

  loadGdriveFileSheets: (configId, fileId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_FILE_SHEETS_LOAD_START
      configurationId: configId
      fileId: fileId

    exGdriveApi.getGdriveFileSheets(configId, fileId)
    .then (result) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_GDRIVE_FILE_SHEETS_LOAD_SUCCESS
        configurationId: configId
        data: result
        fileId: fileId
    .catch (err) =>
      @dispatchApiError(['loadingFiles', configId, fileId], err)
      throw err

  selectSheet: (configId, file, sheet) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_SELECT_SHEET
      configurationId: configId
      file: file
      sheet: sheet

  deselectSheet: (configId, fileId, sheetId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_GDRIVE_DESELECT_SHEET
      configurationId: configId
      fileId: fileId
      sheetId: sheetId


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
      .catch (err) =>
        @dispatchApiError(['savingSheets', configId, fileId, sheetId], err)
        throw err

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
      .catch (err) =>
        @dispatchApiError(['deletingSheets', configId, fileId, sheetId], err)
        throw err
