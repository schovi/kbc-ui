
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
  pendingActions: Map() # by bucket id id
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

  getPendingActions: ->
    _store.get 'pendingActions'

  getPendingActionsForBucket: (bucketId) ->
    @getPendingActions().get(bucketId, Map())


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.TRANSFORMATION_BUCKETS_LOAD
      _store = _store.set 'isLoading', true
      TransformationBucketsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_BUCKETS_LOAD_SUCCESS
      _store = _store.withMutations((store) ->
        store
          .set('isLoading', false)
          .set('isLoaded', true)
          .set('bucketsById', Immutable.fromJS(action.buckets).toMap().mapKeys((key, bucket) ->
            bucket.get 'id'
          ))
      )
      TransformationBucketsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_BUCKET_CREATE_SUCCESS
      _store = _store.setIn ['bucketsById', action.bucket.id], Immutable.fromJS(action.bucket)
      TransformationBucketsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE
      _store = _store.setIn ['pendingActions', action.bucketId, 'delete'], true
      TransformationBucketsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE_ERROR
      _store = _store.deleteIn ['pendingActions', action.bucketId, 'delete']
      TransformationBucketsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .removeIn ['bucketsById', action.bucketId]
        .removeIn ['pendingActions', action.bucketId, 'delete']
      TransformationBucketsStore.emitChange()

module.exports = TransformationBucketsStore
