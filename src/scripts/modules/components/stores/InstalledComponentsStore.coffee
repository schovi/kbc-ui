
Dispatcher = require('../../../Dispatcher')
constants = require '../Constants'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../../utils/StoreUtils'

_store = Map(
  components: Map()
  isLoaded: false
  isLoading: false
)

InstalledComponentsStore = StoreUtils.createStore

  getAll: ->
    _store.get 'components'

  getAllForType: (type) ->
    @getAll().filter((component) ->
      component.get('type') == type
    )

  getComponent: (componentId) ->
    _store.getIn ['components', componentId]    
    
  getConfig: (componentId, configId) ->
    _store.getIn ['components', componentId, 'configurations', configId]

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

    when constants.ActionTypes.INSTALLED_COMPONENTS_UPDATE_CONFIGURATION
      _store = _store.mergeIn ['components', action.componentId, 'configurations', action.configurationId],
        action.data
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


module.exports = InstalledComponentsStore