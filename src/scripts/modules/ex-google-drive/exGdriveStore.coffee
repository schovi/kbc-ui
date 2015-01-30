Dispatcher = require('../../Dispatcher.coffee')
Constants = require './exGdriveConstants.coffee'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../utils/StoreUtils.coffee'


_store = Map(
  configs: Map() #config by configId
  editingSheets: Map() # configId:sheetid
  savingSheets: Map() # configId:sheetid


)



GdriveStore = StoreUtils.createStore
  hasConfig: (configId) ->
    _store.hasIn ['configs',configId]
  getConfig: (configId) ->
    _store.getIn ['configs',configId]

  getConfigSheet: (configId, sheetId) ->
    _store.getIn ['configs', configId, 'items', sheetId]

  isEditingSheet: (configId, sheetId) ->
    _store.hasIn ['editingSheets', configId, sheetId]
  isSavingSheet: (configId, sheetId) ->
    _store.hasIn ['savingSheets', configId, sheetId]
  getEditingSheet: (configId, sheetId) ->
    _store.getIn ['editingSheets', configId, sheetId]
  getSavingSheet: (configId, sheetId) ->
    _store.getIn ['savingSheets', configId, sheetId]




Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.EX_GDRIVE_CONFIGURATION_LOAD_SUCCESS
      configId = action.configuration.id
      configObject = action.configuration.configuration
      _store = _store.setIn(['configs',configId], Immutable.fromJS(configObject))

    when Constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_START
      configId = action.configurationId
      sheetId = action.sheetId
      sheet = GdriveStore.getConfigSheet(configId, sheetId)
      _store = _store.setIn ['editingSheets', configId, sheetId], sheet

    when Constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_CANCEL
      configId = action.configurationId
      sheetId = action.sheetId
      _store = _store.deleteIn ['editingSheets', configId, sheetId], sheet

    when Constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_SAVE_START
      configId = action.configurationId
      sheetId = action.sheetId
      sheet = GdriveStore.getEditingSheet(configId, sheetId)
      _store = _store.setIn ['savingSheets', configId, sheetId], sheet
      _store = _store.deleteIn ['editingSheets', configId, sheetId], sheet

    when Constants.ActionTypes.EX_GDRIVE_SHEET_EDIT_SAVE_END
      configId = action.configurationId
      sheetId = action.sheetId
      sheet = GdriveStore.getSavingSheet(configId, sheetId)
      _store = _store.setIn ['configs', configId, 'items', sheetId], sheet
      _store = _store.deleteIn ['savingSheets', configId, sheetId], sheet

    when Constants.ActionTypes.EX_GDRIVE_SHEET_ON_CHANGE
      configId = action.configurationId
      sheetId = action.sheetId
      propName = action.propName
      newValue = action.newValue
      #sheet = GdriveStore.getEditingSheet(configId, sheetId)
      _store = _store.setIn ['editingSheets', configId, sheetId, propName], newValue









  GdriveStore.emitChange()


module.exports = GdriveStore
