
Dispatcher = require '../../../Dispatcher'
Immutable = require('immutable')
Map = Immutable.Map
List = Immutable.List
Constants = require '../Constants'
fuzzy = require 'fuzzy'
StoreUtils = require '../../../utils/StoreUtils'

_store = Map(
  bucketsById: Map()
  isLoading: false
  isLoaded: false
  loadingBuckets: List()
)

TransformationBucketsStore = StoreUtils.createStore

  ###
    Returns all orchestrations sorted by last execution date desc
  ###
  getAll: ->
    _store
      .get('bucketsById')
      .sortBy((bucket) -> bucket.get('name'))

  ###
    Returns orchestration specified by id
  ###
  get: (id) ->
    _store.getIn ['bucketsById', id]

  has: (id) ->
    _store.get('bucketsById').has id

  getIsLoading: ->
    _store.get 'isLoading'

  getIsLoaded: ->
    _store.get 'isLoaded'


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.TRANSFORMATION_BUCKETS_LOAD
      _store = _store.set 'isLoading', true
      TransformationBucketsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_BUCKETS_LOAD_SUCCESS
      console.log 'load success', payload
      _store = _store.withMutations((store) ->
        store
          .set('isLoading', false)
          .set('isLoaded', true)
          .set('bucketsById', Immutable.fromJS(action.buckets).toMap().mapKeys((key, bucket) ->
            bucket.get 'id'
          ))
      )
      TransformationBucketsStore.emitChange()

module.exports = TransformationBucketsStore