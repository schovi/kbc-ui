
Dispatcher = require '../../../Dispatcher'
Immutable = require('immutable')
Map = Immutable.Map
List = Immutable.List
Constants = require '../Constants'
fuzzy = require 'fuzzy'
StoreUtils = require '../../../utils/StoreUtils'
_ = require 'underscore'

_store = Map(
  transformationsByBucketId: Map()
  loadingTransformationBuckets: List()
  pendingActions: Map()
)

addToLoadingBuckets = (store, bucketId) ->
  store.update 'loadingTransformationBuckets', (loadingTransformationBuckets) ->
    loadingTransformationBuckets.push bucketId

removeFromLoadingBuckets = (store, bucketId) ->
  store.update 'loadingTransformationBuckets', (loadingTransformationBuckets) ->
    loadingTransformationBuckets.remove(loadingTransformationBuckets.indexOf(bucketId))

TransformationsStore = StoreUtils.createStore

  ###
    Returns all transformations for bucket id
  ###
  getTransformations: (bucketId) ->
    _store
      .getIn(['transformationsByBucketId', bucketId], List())
      .sortBy((transformation) ->
        phase = transformation.get('phase') || "1"
        name = transformation.get('friendlyName') || transformation.get('id')
        phase + name.toLowerCase()
      )
  ###
    Check if store contains transformations for specified bucket
  ###
  hasTransformations: (bucketId) ->
    _store.get('transformationsByBucketId').has bucketId

  ###
    Returns one transformation by its id
  ###
  getTransformation: (bucketId, transformationId) ->
    _store.getIn ['transformationsByBucketId', bucketId, transformationId]

  hasTransformation: (bucketId, transformationId) ->
    _store.hasIn ['transformationsByBucketId', bucketId, transformationId]

  ###
    Test if specified transformation buckets are currently being loaded
  ###
  isBucketLoading: (bucketId) ->
    _store.get('loadingTransformationBuckets').contains bucketId

  getPendingActions: (bucketId) ->
    _store.getIn ['pendingActions', bucketId], Map()

  getTransformationPendingActions: (bucketId, transformationId) ->
    _store.getIn ['pendingActions', bucketId, transformationId], Map()

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when Constants.ActionTypes.TRANSFORMATIONS_LOAD
      _store = addToLoadingBuckets(_store, action.bucketId)
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATIONS_LOAD_ERROR
      _store = removeFromLoadingBuckets(_store, action.bucketId)
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATIONS_LOAD_SUCCESS
      _store = _store.withMutations((store) ->
        _.each(action.transformations, (transformation) ->
          tObj = Immutable.fromJS(transformation)
          store = store.setIn ['transformationsByBucketId', action.bucketId, tObj.get 'id'], tObj
        )
        store = removeFromLoadingBuckets(store, action.bucketId)
      )
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_DELETE
      _store = _store.setIn ['pendingActions', action.bucketId, action.transformationId, 'delete'], true
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_DELETE_SUCCESS
      _store = _store.withMutations (store) ->
        store = store
        .removeIn ['transformationsByBucketId', action.bucketId, action.transformationId]
        .removeIn ['pendingActions', action.bucketId, action.transformationId, 'delete']
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_DELETE_ERROR
      _store = _store.removeIn ['pendingActions', action.bucketId, action.transformationId, 'delete']
      TransformationsStore.emitChange()


module.exports = TransformationsStore
