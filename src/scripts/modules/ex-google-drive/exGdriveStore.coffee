Dispatcher = require('../../Dispatcher.coffee')
Constants = require './exGdriveConstants.coffee'
Immutable = require('immutable')
Map = Immutable.Map
Iterable = Immutable.Iterable
StoreUtils = require '../../utils/StoreUtils.coffee'


_store = Map(
  configs: Map() #config by configId
  editingSheets: Map() #configId:fileId:sheetId
  savingSheets: Map() #configId:fileId:sheetId
  deletingSheets: Map() #configId:fileId:sheetId
  documents: Map() #configId:fileId:sheetId
  loadingFiles: Map() #configId:fileId
  selectedSheets: Map() #configId:fileId:sheetId -> (sheet&file)
  nextPageToken: Map() #configId:nextPagetoken
  loadingMore: Map() #configId loading more files for
  searchQuery: Map() #configId:value
  savingNewSheets: Map() #configId: array
)



GdriveStore = StoreUtils.createStore
  hasConfig: (configId) ->
    _store.hasIn ['configs',configId]
  getConfig: (configId) ->
    _store.getIn ['configs',configId]
  getDeletingSheets: (configId) ->
    _store.getIn ['deletingSheets', configId]

  getConfigSheet: (configId, fileId, sheetId) ->
    items = _store.getIn ['configs', configId, 'items']
    result = items.find (value, key) ->
      value.get('fileId') == fileId and value.get('sheetId')
    return result

  hasGdriveFiles: (configId) ->
    return _store.hasIn ['documents', configId]


  isDeletingSheet: (configId, fileId, sheetId) ->
    _store.hasIn ['deletingSheets', configId, fileId, sheetId]
  isEditingSheet: (configId, fileId, sheetId) ->
    _store.hasIn ['editingSheets', configId, fileId, sheetId]
  isSavingSheet: (configId, fileId, sheetId) ->
    _store.hasIn ['savingSheets', configId, fileId, sheetId]
  getEditingSheet: (configId, fileId, sheetId) ->
    _store.getIn ['editingSheets', configId, fileId, sheetId]
  getSavingSheet: (configId, fileId, sheetId) ->
    _store.getIn ['savingSheets', configId, fileId, sheetId]
  getSheetValidation: (configId, fileId, sheetId) ->
    _store.getIn ["validationSheets", configId, fileId, sheetId]
  isSheetValid: (configId, fileId, sheetId) ->
    validation = _store.getIn ["validationSheets", configId, fileId, sheetId]
    #sheet is valid if its validation object
    #  does not contains any properties(ie messages)
    return validation != null and Object.keys(validation).length == 0

  getGdriveFiles: (configId) ->
    _store.getIn ['documents', configId]
  getLoadingFiles: (configId) ->
    _store.getIn ['loadingFiles', configId]
  getSelectedSheets: (configId) ->
    _store.getIn ['selectedSheets', configId]
  getNextPageToken: (configId) ->
    _store.getIn ['nextPageToken', configId]
  isLoadingMore: (configId) ->
    _store.hasIn ['loadingMore', configId]
  getSearchQueryValue: (configId) ->
    _store.getIn ['searchQuery', configId]
  getSavingNewSheets: (configId) ->
    _store.getIn ['savingNewSheets', configId]
  isSavingNewSheets: (configId) ->
    _store.hasIn ['savingNewSheets', configId]

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    # GOOGLE DRIVE FILES/SHEETS SELECTION
    when Constants.ActionTypes.EX_GDRIVE_SAVING_SHEETS_SUCCESS
      configId = action.configurationId
      data = action.data
      _store = _store.withMutations( (store) ->
        store
          .deleteIn ['savingNewSheets', configId]
          .deleteIn ['searchQuery', configId]
          .deleteIn ['documents', configId]
          .deleteIn ['selectedSheets', configId]
          .deleteIn ['nextPageToken', configId]
          .deleteIn ['configs', configId]
      )
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SAVING_SHEETS_START
      configId = action.configurationId
      selectedSheets = GdriveStore.getSelectedSheets(configId)
      sheetsToSave  = selectedSheets.map((sheets, fileId) ->
        sheets.map((sheet, sheetId) ->
          googleId: fileId
          sheetTitle: sheet.get 'title'
          sheetId: sheetId
          title: sheet.getIn(['file', 'title'])).toList()).toList().flatten(true)
      _store = _store.setIn ['savingNewSheets', configId], sheetsToSave
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_LOADING_MORE_START
      configId = action.configurationId
      _store = _store.setIn ['loadingMore', configId]
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SEARCH_QUERY_CHANGE
      configId = action.configurationId
      value = action.value
      _store = _store.setIn ['searchQuery', configId], value
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_LOADING_MORE_SUCCESS
      configId = action.configurationId
      oldNextToken = action.nextPageToken
      data = action.data.items
      newNextToken = data.nextPageToken or null
      _store = _store.setIn ['nextPageToken', configId], newNextToken
      _store = _store.deleteIn ['loadingMore', configId]
      newFiles = Immutable.fromJS(data).toMap().mapKeys (key, file) ->
        return file.get('id')
      _store = _store.mergeIn ['documents', configId], newFiles
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_FILES_LOAD_SUCCESS
      nextToken = action.data.nextPageToken
      files = action.data.items
      configId = action.configurationId
      if nextToken
        _store = _store.setIn ['nextPageToken', configId], nextToken
      files = Immutable.fromJS(files).toMap().mapKeys (key, file) ->
        return file.get('id')
      _store = _store.setIn ['documents', configId], files
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_FILE_SHEETS_LOAD_START
      fileId = action.fileId
      configId = action.configurationId
      _store = _store.setIn ['loadingFiles', configId, fileId]
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_FILE_SHEETS_LOAD_SUCCESS
      fileId = action.fileId
      data = action.data
      configId = action.configurationId
      _store = _store.deleteIn ['loadingFiles', configId, fileId]
      sheets = Immutable.fromJS(data)
      _store = _store.setIn ['documents', configId, fileId, 'sheets'], sheets
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SELECT_SHEET
      fileId = action.file.get 'id'
      sheetId = action.sheet.get 'id'
      configId = action.configurationId
      item = action.sheet.set('file', action.file)
      _store = _store.setIn ['selectedSheets', configId, fileId, sheetId], item
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_DESELECT_SHEET
      fileId = action.fileId
      sheetId = action.sheetId
      configId = action.configurationId
      _store = _store.deleteIn ['selectedSheets', configId, fileId, sheetId]
      GdriveStore.emitChange()



    #WORKING WITH CONFIGURATION
    when Constants.ActionTypes.EX_GDRIVE_CONFIGURATION_LOAD_SUCCESS
      configId = action.configuration.id
      configObject = action.configuration.configuration
      _store = _store.setIn(['configs',configId], Immutable.fromJS(configObject))
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_VALIDATE
      configId = action.configurationId
      sheetId = action.sheetId
      fileId =  action.fileId
      sheet = GdriveStore.getEditingSheet(configId, fileId, sheetId)
      validation = {}
      _store = _store.setIn ["validationSheets", configId, fileId, sheetId], validation
      configStr = sheet.get 'config'
      try
        config = JSON.parse(configStr)
        if config == null
          validation.config = 'Can not be empty'
        else
          if not config?.db?.table
            validation.table = 'Can not be empty'
          else
            table = config.db.table
            if table.split('.')[0] != 'in'
              validation.table = "Bucket must be of stage 'in'"
          if not config?.header?.rows?
            validation.header = 'Can not be empty.'
          else
            if not isFinite(config.header.rows)
              validation.header = 'Must be valid number'
            else
              if parseInt(config.header.rows) < 0
                validation.header = 'Can not be negative integer'
      catch
        validation.config = 'Must be valid JSON object'
      _store = _store.setIn ["validationSheets", configId, fileId, sheetId], validation
      GdriveStore.emitChange()



    when Constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_START
      configId = action.configurationId
      sheetId = action.sheetId
      fileId =  action.fileId
      sheet = GdriveStore.getConfigSheet(configId, fileId, sheetId)
      _store = _store.setIn ['editingSheets', configId, fileId, sheetId], sheet
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_CANCEL
      configId = action.configurationId
      sheetId = action.sheetId
      fileId =  action.fileId
      _store = _store.deleteIn ['editingSheets', configId, fileId, sheetId]
      _store = _store.deleteIn ['validationSheets', configId, fileId, sheetId]
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_SAVE_START
      configId = action.configurationId
      sheetId = action.sheetId
      fileId =  action.fileId
      sheet = GdriveStore.getEditingSheet(configId, fileId, sheetId)
      _store = _store.setIn ['savingSheets', configId, fileId, sheetId], sheet
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_SAVE_END
      configId = action.configurationId
      sheetId = action.sheetId
      fileId =  action.fileId
      sheet = GdriveStore.getSavingSheet(configId, fileId, sheetId)
      #update configured sheets store with sheet by fileId == sheetId
      items = _store.getIn ['configs', configId, 'items']
      newItems = items.map( (value, key) ->
        if value.get('fileId') == fileId and value.get('sheetId') == sheetId
          return sheet
        else
          return value
        )
      _store = _store.setIn ['configs', configId, 'items'], newItems
      _store = _store.deleteIn ['editingSheets', configId, fileId, sheetId]
      _store = _store.deleteIn ['savingSheets', configId, fileId, sheetId]

      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SHEET_ON_CHANGE
      configId = action.configurationId
      sheetId = action.sheetId
      fileId =  action.fileId
      propName = action.propName
      newValue = action.newValue
      #sheet = GdriveStore.getEditingSheet(configId, sheetId)
      _store = _store.setIn ['editingSheets', configId, fileId, sheetId, propName], newValue
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SHEET_DELETE_START
      configId = action.configurationId
      sheetId = action.sheetId
      fileId =  action.fileId
      sheet = GdriveStore.getConfigSheet(configId, fileId, sheetId)
      _store = _store.setIn ['deletingSheets', configId, fileId, sheetId], sheet
      GdriveStore.emitChange()

    when Constants.ActionTypes.EX_GDRIVE_SHEET_DELETE_END
      configId = action.configurationId
      sheetId = action.sheetId
      fileId =  action.fileId
      _store = _store.deleteIn ['deletingSheets', configId, fileId, sheetId]

      items = _store.getIn ['configs', configId, 'items']
      newItems = items.filter (value,key) ->
        value.get('fileId') != fileId and value.get('sheetId') != sheetId
      _store = _store.setIn ['configs', configId, 'items'], newItems
      GdriveStore.emitChange()

module.exports = GdriveStore
