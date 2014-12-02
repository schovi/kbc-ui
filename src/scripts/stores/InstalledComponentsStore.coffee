
Dispatcher = require('../dispatcher/KbcDispatcher.coffee')
constants = require '../constants/KbcConstants.coffee'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../utils/StoreUtils.coffee'

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

  getIsLoaded: ->
    _store.get 'isLoaded'

  getIsLoading: ->
    _store.get 'isLoading'


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when constants.ActionTypes.INSTALLED_COMPONENTS_LOAD
      _store = _store.set 'isLoading', true
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_ERROR
      _store = _store.set 'isLoading', false
      InstalledComponentsStore.emitChange()

    when constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_SUCCESS
      _store = _store.withMutations((store) ->
        store
          .set('isLoaded', true)
          .set('isLoading', false)
          .set('components', Immutable.fromJS action.components)
      )
      InstalledComponentsStore.emitChange()


module.exports = InstalledComponentsStore