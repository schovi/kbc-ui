
StoreUtils = require '../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../Dispatcher'
constants = require './constants'

{Map} = Immutable


_store = Map
  writers: Map()

GoodDataWriterStore = StoreUtils.createStore


  hasWriter: (configurationId) ->
    _store.hasIn ['writers', configurationId]

  getWriter: (configurationId) ->
    _store.getIn ['writers', configurationId]

  getWriterTables: (configurationId) ->


dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_START
      _store = _store.setIn ['writers', action.configurationId, 'isLoading'], true
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_ERROR
      _store = _store.setIn ['writers', action.configurationId, 'isLoading'], false
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .setIn ['writers', action.configuration.id, 'isLoading'], false
        .setIn ['writers', action.configuration.id, 'config'], Immutable.fromJS action.configuration.writer
        .setIn ['writers', action.configuration.id, 'tables'], Immutable.fromJS action.configuration.tables
      GoodDataWriterStore.emitChange()

module.exports = GoodDataWriterStore