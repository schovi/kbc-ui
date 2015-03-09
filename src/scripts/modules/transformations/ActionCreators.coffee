dispatcher = require '../../Dispatcher'
constants = require './Constants'
transformationsApi = require './TransformationsApi'
TransformationBucketsStore = require './stores/TransformationBucketsStore'
TransformationsStore = require './stores/TransformationsStore'
Promise = require 'bluebird'

module.exports =

  ###
    Request orchestrations reload from server
  ###
  loadTransformationBucketsForce: ->
    actions = @

    # trigger load initialized
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_BUCKETS_LOAD
    )

    # init load
    transformationsApi
    .getTransformationBuckets()
    .then((buckets) ->
      # load success
      actions.receiveAllTransformationBuckets(buckets)
    )
    .catch (err) ->
      throw err

  receiveAllTransformationBuckets: (buckets) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_BUCKETS_LOAD_SUCCESS
      buckets: buckets
    )

  ###
    Request transformation buckets load only if not already loaded
    @return Promise
  ###
  loadTransformationBuckets: ->
    # don't load if already loaded
    return Promise.resolve() if TransformationBucketsStore.getIsLoaded()

    @.loadTransformationBucketsForce()

  createTransformationBucket: (data) ->
    transformationsApi
    .createTransformationBucket(data)
    .then((newBucket) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_BUCKET_CREATE_SUCCESS
        bucket: newBucket
      )
    )

  deleteTransformationBucket: (bucketId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE_START
      bucketId: bucketId

    transformationsApi
    .deleteTransformationBucket(bucketId)
    .then ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE_SUCCESS
        bucketId: bucketId
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE_ERROR
        bucketId: bucketId
      throw e

  ###
    Request specified orchestration load from server
    @return Promise
  ###
  loadTransformationsForce: (bucketId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATIONS_LOAD
      bucketId: bucketId
    )

    transformationsApi
    .getTransformations(bucketId)
    .then((transformations) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATIONS_LOAD_SUCCESS
        transformations: transformations
        bucketId: bucketId
      )
      return
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATIONS_LOAD_ERROR
        bucketId: bucketId
      )
      throw error
    )

  loadTransformations: (bucketId) ->
    return Promise.resolve() if TransformationsStore.hasTransformations bucketId
    @loadTransformationsForce(bucketId)


  deleteTransformation: (bucketId, transformationId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_DELETE
      bucketId: bucketId
      transformationId: transformationId
    )

    transformationsApi
    .deleteTransformation(bucketId, transformationId)
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_DELETE_SUCCESS
        transformationId: transformationId
        bucketId: bucketId
      )
      return
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_DELETE_ERROR
        transformationId: transformationId
        bucketId: bucketId
      )
      throw error
    )

