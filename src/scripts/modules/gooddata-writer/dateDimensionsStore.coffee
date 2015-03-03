
StoreUtils = require '../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../Dispatcher'
constants = require './constants'

{Map, List} = Immutable


_store = Map
  dimensionsById: Map()
  isLoading: false


DimensionsStore = StoreUtils.createStore

  getAll: (configurationId) ->
    _store.getIn ['dimensionsById', configurationId]

dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_DATE_DIMENSIONS_START
      _store = _store.set 'isLoading', true
      DimensionsStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_DATE_DIMENSIONS_ERROR
      _store = _store.set 'isLoading', false
      DimensionsStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_DATE_DIMENSIONS_SUCCESS
      dimensionsById = Immutable
      .fromJS(action.dimensions)
      .map (dimension, id) ->
        Map
          isLoading: false
          id: id
          pendingActions: List()
          data: dimension

      _store = _store.withMutations (store) ->
        store
        .set 'isLoading', false
        .setIn ['dimensionsById', action.configurationId], dimensionsById

      DimensionsStore.emitChange()
      console.log 'store', _store.toJS()


    when constants.ActionTypes.GOOD_DATA_WRITER_DATE_DIMENSION_DELETE_START
      _store = _store.updateIn [
        'dimensionsById'
        action.configurationId
        action.dimensionName
        'pendingActions'
      ], (actions) ->
        actions.push 'delete'
      DimensionsStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_DATE_DIMENSION_DELETE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .updateIn [
          'dimensionsById'
          action.configurationId
          action.dimensionName
          'pendingActions'
        ], (actions) ->
          actions.delete(actions.indexOf 'delete')
        .deleteIn [
          'dimensionsById'
          action.configurationId
          action.dimensionName
        ]
      DimensionsStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_DATE_DIMENSION_DELETE_ERROR
      _store = _store.updateIn [
        'dimensionsById'
        action.configurationId
        action.dimensionName
        'pendingActions'
      ], (actions) ->
        actions.delete(actions.indexOf 'delete')
      DimensionsStore.emitChange()

module.exports = DimensionsStore