
StoreUtils = require '../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../Dispatcher'
constants = require './constants'

{Map, List} = Immutable


_store = Map
  dimensionsById: Map()
  newDimensions: Map()
  isLoading: Map()


DimensionsStore = StoreUtils.createStore

  getAll: (configurationId) ->
    _store.getIn ['dimensionsById', configurationId]

  isLoading: (configurationId) ->
    _store.hasIn ['isLoading', configurationId]

  isCreatingNewDimension: (configurationId) ->
    _store.hasIn ['newDimensions', configurationId, 'isSaving']

  getNewDimension: (configurationId) ->
    _store.getIn ['newDimensions', configurationId, 'dimension'],
      Map
        name: ''
        includeTime: false

dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_DATE_DIMENSIONS_START
      _store = _store.setIn ['isLoading', action.configurationId], true
      DimensionsStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_DATE_DIMENSIONS_ERROR
      _store = _store.deleteIn ['isLoading', action.configurationId]
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
        .deleteIn ['isLoading', action.configurationId]
        .setIn ['dimensionsById', action.configurationId], dimensionsById

      DimensionsStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_DATE_DIMENSION_UPLOAD_START
      _store = _store.updateIn [
        'dimensionsById'
        action.configurationId
        action.dimensionName
        'pendingActions'
      ], (actions) ->
        actions.push 'upload'
      DimensionsStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_DATE_DIMENSION_UPLOAD_SUCCESS, constants.ActionTypes
      .GOOD_DATA_WRITER_DATE_DIMENSION_UPLOAD_ERROR
        _store = _store.withMutations (store) ->
          store
          .updateIn [
            'dimensionsById'
            action.configurationId
            action.dimensionName
            'pendingActions'
          ], (actions) ->
            actions.delete(actions.indexOf 'upload')
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


    when constants.ActionTypes.GOOD_DATA_WRITER_NEW_DATE_DIMENSION_UPDATE
      _store = _store.setIn [
        'newDimensions'
        action.configurationId
        'dimension'
      ], action.dimension
      DimensionsStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_NEW_DATE_DIMENSION_SAVE_START
      _store = _store.setIn [
        'newDimensions'
        action.configurationId
        'isSaving'
      ], true
      DimensionsStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_NEW_DATE_DIMENSION_SAVE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .deleteIn [
          'newDimensions'
          action.configurationId
        ]
        .setIn [
          'dimensionsById'
          action.configurationId
          action.dimension.get('name')
        ], Map
          isLoading: false
          id: action.dimension.get('name')
          pendingActions: List()
          data: action.dimension

      DimensionsStore.emitChange()



module.exports = DimensionsStore