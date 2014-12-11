Immutable = require('immutable')
StoreUtils = require('../../../utils/StoreUtils.coffee')
Constants = require('../Constants.coffee')
Dispatcher = require '../../../Dispatcher.coffee'


Map = Immutable.Map
List = Immutable.List

_store = Map(
  jobsById: Map()
  filter:''
  isLoading: false
  isLoaded: false
  )

JobsStore = StoreUtils.createStore
  getAll: ->
    _store
      .get('jobsById')
      #.sortBy(TODO)
  get: (id) ->
    _store.getIn ['jobsById', parseInt(id)]
  getIsLoading: ->
    _store.get 'isLoading'
  getIsLoaded: ->
    _store.get 'isLoaded'

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.JOBS_LOAD
      _store = _store.set 'isLoading', true
      JobsStore.emitChange()
    when Constants.ActionTypes.JOBS_LOAD_SUCCESS
      _store = _store.withMutations((store) ->
        store
          .set('isLoading', false)
          .set('isLoaded', true)
          .set('jobsById', Immutable.fromJS(action.jobs).toMap())
      )
      JobsStore.emitChange()




module.exports = JobsStore
