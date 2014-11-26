
EventEmitter = require('events').EventEmitter
Dispatcher = require('../dispatcher/KbcDispatcher.coffee')
assign = require 'object-assign'
Constants = require '../constants/KbcConstants.coffee'
Immutable = require('immutable')
fuzzy = require 'fuzzy'

_store = Immutable.fromJS(
  components: {}
  filter: {}
)

CHANGE_EVENT = 'change'

ComponentsStore = assign {}, EventEmitter.prototype,

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

  addChangeListener: (callback) ->
      @on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(CHANGE_EVENT, callback)

  emitChange: ->
    @emit(CHANGE_EVENT)


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.COMPONENTS_SET_FILTER
      _store = _store.setIn ['filter', action.componentType], action.query.trim()

    when Constants.ActionTypes.COMPONENTS_LOAD_SUCCESS
      _store = _store.set 'components', Immutable.fromJS(action.components).toMap().mapKeys((key, component) ->
        component.get 'id'
      )

  ComponentsStore.emitChange()
  true

module.exports = ComponentsStore