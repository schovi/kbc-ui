
Dispatcher = require('../../../Dispatcher')
constants = require '../Constants'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../../utils/StoreUtils'

_store = Map(
  components: Map()
  editingConfigurations: Map()
  savingConfigurations: Map()
  deletingConfigurations: Map()
  isLoaded: false
  isLoading: false
)

InstalledComponentsStore = StoreUtils.createStore

  getAll: ->
    _store
    .get 'components'
    .sortBy (component) -> component.get 'name'

  getAllForType: (type) ->
    @getAll().filter (component) ->
      component.get('type') == type

  getComponent: (componentId) ->
    _store.getIn ['components', componentId]

  getConfig: (componentId, configId) ->
    _store.getIn ['components', componentId, 'configurations', configId]

  isEditingConfig: (componentId, configId, field) ->
    _store.hasIn ['editingConfigurations', componentId, configId, field]

  getEditingConfig: (componentId, configId, field) ->
    _store.getIn ['editingConfigurations', componentId, configId, field]

  isValidEditingConfig: (componentId, configId, field) ->
    value = @getEditingConfig(componentId, configId, field)
    return true if value == undefined
    switch field
      when 'description' then true
      when 'name' then value.trim().length > 0


  isDeletingConfig: (componentId, configId) ->
    _store.hasIn ['deletingConfigurations', componentId, configId]

  isSavingConfig: (componentId, configId, field) ->
    _store.hasIn ['savingConfigurations', componentId, configId, field]

  getIsLoading: ->
    _store.get 'isLoading'

  getIsLoaded: ->
    _store.get 'isLoaded'


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when constants.ActionTypes.INSTALLED_COMPONENTS_LOAD
      _store = _store.set 'isLoading', true
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_ERROR
      _store = _store.set 'isLoading', false
      InstalledComponentsStore.emitChange()



    when constants.ActionTypes.INSTALLED_COMPONENTS_CONFIGURATION_EDIT_START
      _store = _store.withMutations (store) ->
        store.setIn ['editingConfigurations', action.componentId, action.configurationId, action.field],
          InstalledComponentsStore.getConfig(action.componentId, action.configurationId).get action.field
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_CONFIGURATION_EDIT_UPDATE
      console.log 'update', action.field, action.value
      _store = _store.setIn ['editingConfigurations', action.componentId, action.configurationId, action.field],
        action.value
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_CONFIGURATION_EDIT_CANCEL
      _store = _store.deleteIn ['editingConfigurations', action.componentId, action.configurationId, action.field]
      InstalledComponentsStore.emitChange()


    when constants.ActionTypes.INSTALLED_COMPONENTS_DELETE_CONFIGURATION_START
      _store = _store.setIn ['deletingConfigurations', action.componentId, action.configurationId], true
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_DELETE_CONFIGURATION_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .deleteIn ['components', action.componentId, 'configurations', action.configurationId]
        .deleteIn ['deletingConfigurations', action.componentId, action.configurationId]
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_DELETE_CONFIGURATION_ERROR
      _store = _store.deleteIn ['deletingConfigurations', action.componentId, action.configurationId]
      InstalledComponentsStore.emitChange()



    when constants.ActionTypes.INSTALLED_COMPONENTS_UPDATE_CONFIGURATION_START
      _store = _store.setIn ['savingConfigurations', action.componentId, action.configurationId, action.field], true
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_UPDATE_CONFIGURATION_ERROR
      _store = _store.deleteIn ['savingConfigurations', action.componentId, action.configurationId, action.field]
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_UPDATE_CONFIGURATION_SUCCESS
      _store = _store.withMutations (store) ->
        store
          .mergeIn ['components', action.componentId, 'configurations', action.configurationId],
            Immutable.fromJS(action.data)
          .deleteIn ['savingConfigurations', action.componentId, action.configurationId, action.field]
          .deleteIn ['editingConfigurations', action.componentId, action.configurationId, action.field]
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_SUCCESS
      _store = _store.withMutations((store) ->
        store
          .set('isLoading', false)
          .set('isLoaded', true)
          .set('components',
            ## convert to by key structure
            Immutable.fromJS(action.components)
            .toMap()
            .map((component) ->
              component.set 'configurations', component.get('configurations').toMap().mapKeys((key, config) ->
                config.get 'id'
              )
            )
            .mapKeys((key, component) ->
              component.get 'id'
            ))
      )
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_SUCCESS
      _store = _store.setIn ['components', action.componentId, 'configurations', action.configuration.id],
        Immutable.fromJS action.configuration

      InstalledComponentsStore.emitChange()


module.exports = InstalledComponentsStore
