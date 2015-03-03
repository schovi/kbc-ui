

dispatcher = require '../../Dispatcher'
constants = require './Constants'
transformationsApi = require './TransformationsApi'
TransformationBucketsStore = require './stores/TransformationBucketsStore'
TransformationsStore = require './stores/TransformationBucketsStore'
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
      )
      return
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATIONS_LOAD_ERROR
      )
      throw error
    )

  loadTransformations: (bucketId) ->
    return Promise.resolve() if TransformationsStore.has(bucketId)
    @loadTransformationsForce(bucketId)

  createSandbox: (data) ->
    transformationsApi
    .createSandbox(data)
    .then((job) ->
      console.log "job", job
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_SANDBOX_CREATE_SUCCESS
        job: job
      )
    )
