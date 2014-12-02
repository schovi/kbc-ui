
Dispatcher = require('../dispatcher/KbcDispatcher.coffee')
Constants = require '../constants/KbcConstants.coffee'
Immutable = require('immutable')
Map = Immutable.Map
fuzzy = require 'fuzzy'
StoreUtils = require '../utils/StoreUtils.coffee'

_store = Map(
  components: Map()
  filter: Map()
)

ComponentsStore = StoreUtils.createStore

  getAll: ->
    _store.get 'components'

  getAllForType: (type) ->
    _store.get('components').filter((component) ->
      component.get('type') == type
    )

  getFilteredForType: (type) ->
    filter = @getFilter(type)
    all = @getAllForType(type)
    all.filter((component) -> fuzzy.match(filter, component.get 'name'))

  getFilter: (type) ->
    _store.getIn(['filter', type]) || ''

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.COMPONENTS_SET_FILTER
      _store = _store.setIn ['filter', action.componentType], action.query.trim()
      ComponentsStore.emitChange()

    when Constants.ActionTypes.COMPONENTS_LOAD_SUCCESS
      _store = _store.set 'components', Immutable.fromJS(action.components).toMap().mapKeys((key, component) ->
        component.get 'id'
      )
      ComponentsStore.emitChange()


module.exports = ComponentsStore