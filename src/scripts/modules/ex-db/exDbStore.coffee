
Dispatcher = require('../../Dispatcher.coffee')
constants = require './exDbConstants.coffee'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../utils/StoreUtils.coffee'

_store = Map(
  configs: Map()
)

ExDbStore = StoreUtils.createStore

  getConfig: (configId) ->
    _store.getIn ['configs', configId]

  hasConfig: (configId) ->
    _store.hasIn ['configs', configId]

  getConfigQuery: (configId, queryId) ->
    _store.getIn(['configs', configId, 'queries']).find (query) ->
      parseInt(query.get 'id') == parseInt(queryId)

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when constants.ActionTypes.EX_DB_CONFIGURATION_LOAD_SUCCESS
      _store = _store.withMutations (store) ->
        store.setIn ['configs', action.configuration.id], Immutable.fromJS(action.configuration)

      console.log 'load', _store.toJS()
      ExDbStore.emitChange()


module.exports = ExDbStore