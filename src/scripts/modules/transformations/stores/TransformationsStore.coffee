
Dispatcher = require '../../../Dispatcher'
Immutable = require('immutable')
Map = Immutable.Map
List = Immutable.List
Constants = require '../Constants'
fuzzy = require 'fuzzy'
StoreUtils = require '../../../utils/StoreUtils'

_store = Map(
  transformationsByBucketId: Map()
  loadingTransformationBuckets: List()
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
    .sortBy((transformation) -> transformation.get 'phase')
    .sortBy((transformation) -> transformation.get 'name')

###
  Check if store contains transformations for specified bucket
###
  hasTransformations: (bucketId) ->
    _store.get('transformationsByBucketId').has bucketId

###
  Returns one transformation by its id
###
  getTransformation: (transformationId) ->
    foundTransformation = null
    _store.get('transformationsByBucketId').find (transformations) ->
      foundTransformation = transformations.find (transformation) -> transformation.get('id') == transformationId
    foundTransformation

###
  Test if specified transformation buckets are currently being loaded
###
  isBucketLoading: (bucketId) ->
    _store.get('loadingTransformationBuckets').contains bucketId


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
        removeFromLoadingBuckets(store, action.orchestrationId)
        .update('transformationsByBucketId', (transformationsByBucketId) ->
          console.log action
          transformationsByBucketId.set action.bucketId, Immutable.fromJS(action.items)
        )
      )
      TransformationsStore.emitChange()

module.exports = TransformationsStore