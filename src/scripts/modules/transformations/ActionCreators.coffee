dispatcher = require '../../Dispatcher'
constants = require './Constants'
transformationsApi = require './TransformationsApiAdapter'
TransformationBucketsStore = require './stores/TransformationBucketsStore'
TransformationsStore = require './stores/TransformationsStore'
InstalledComponentsActionCreators = require '../components/InstalledComponentsActionCreators'
RoutesStore = require '../../stores/RoutesStore'
Promise = require 'bluebird'
_ = require 'underscore'
parseQueries = require('./utils/parseQueries').default
VersionActionCreators = require('../components/VersionsActionCreators')

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
      actions.receiveTransformationBuckets(buckets)
    )
    .catch (err) ->
      throw err

  receiveTransformationBuckets: (buckets) ->
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
    newBucket = {}
    transformationsApi
    .createTransformationBucket(data)
    .then((bucket) ->
      newBucket = bucket
      InstalledComponentsActionCreators.loadComponentsForce()
    )
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_BUCKET_CREATE_SUCCESS
        bucket: newBucket
      )
      RoutesStore.getRouter().transitionTo 'transformationBucket',
        bucketId: newBucket.id
    )

  createTransformation: (bucketId, data) ->
    transformationsApi
    .createTransformation bucketId, data.toJS()
    .then (transformation) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_CREATE_SUCCESS
        bucketId: bucketId
        transformation: transformation
      )
      RoutesStore.getRouter().transitionTo 'transformationDetail',
        transformationId: transformation.id
        bucketId: bucketId


  deleteTransformationBucket: (bucketId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE
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
      VersionActionCreators.loadVersionsForce('transformation', bucketId)
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

  ###
    Request overview load from server
  ###
  loadTransformationOverview: (bucketId, transformationId, showDisabled) ->
    actions = @
    _.defer( ->
      # trigger load initialized
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_OVERVIEW_LOAD
        transformationId: transformationId
        bucketId: bucketId
      )

      tableId = bucketId + "." + transformationId
      # init load
      transformationsApi
      .getGraph
        tableId: tableId
        direction: 'around'
        showDisabled: showDisabled
        limit: {sys: [bucketId]}
      .then((graphData) ->
        # load success
        dispatcher.handleViewAction(
          type: constants.ActionTypes.TRANSFORMATION_OVERVIEW_LOAD_SUCCESS
          transformationId: transformationId
          bucketId: bucketId
          model: graphData
        )

      )
      .catch((error) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.TRANSFORMATION_OVERVIEW_LOAD_ERROR
          transformationId: transformationId
          bucketId: bucketId
        )
        throw error
      )
    )

  showTransformationOverviewDisabled: (bucketId, transformationId, showDisabled) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_OVERVIEW_SHOW_DISABLED
      transformationId: transformationId
      bucketId: bucketId
      showDisabled: showDisabled
    )
    @loadTransformationOverview(bucketId, transformationId, showDisabled)

  toggleOpenInputMapping: (bucketId, transformationId, index) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_INPUT_MAPPING_OPEN_TOGGLE
      transformationId: transformationId
      bucketId: bucketId
      index: index
    )

  toggleOpenOutputMapping: (bucketId, transformationId, index) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_OUTPUT_MAPPING_OPEN_TOGGLE
      transformationId: transformationId
      bucketId: bucketId
      index: index
    )

  changeTransformationProperty: (bucketId, transformationId, propertyName, newValue) ->
    pendingAction = "save-#{propertyName}"

    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_START
      transformationId: transformationId
      bucketId: bucketId
      pendingAction: pendingAction
    )

    transformation = TransformationsStore.getTransformation(bucketId, transformationId)
    transformation = transformation.set(propertyName, newValue)

    transformationsApi
    .saveTransformation(bucketId, transformationId, transformation.toJS())
    .then (response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_SUCCESS
        transformationId: transformationId
        bucketId: bucketId
        editingId: propertyName
        pendingAction: pendingAction
        data: response
      )
      VersionActionCreators.loadVersionsForce('transformation', bucketId)
    .catch (error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_ERROR
        transformationId: transformationId
        bucketId: bucketId
        editingId: propertyName
        pendingAction: pendingAction
        error: error
      )
      throw error

    ###

    dispatcher.handleViewAction
      type: constants.ActionTypes.TRANSFORMATION_CHANGE_PROPERTY_START
      bucketId: bucketId
      transformationId: transformationId
      propertyName: propertyName




    transformationsApi
    .updateTransformationProperty(bucketId, transformationId, propertyName, newValue)
    .then ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.TRANSFORMATION_CHANGE_PROPERTY_SUCCESS
        bucketId: bucketId
        transformationId: transformationId
        propertyName: propertyName
        newValue: newValue
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.TRANSFORMATION_CHANGE_PROPERTY_ERROR
        bucketId: bucketId
        transformationId: transformationId
        propertyName: propertyName
        error: e
      throw e
      ###

  setTransformationBucketsFilter: (query) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.TRANSFORMATION_BUCKETS_FILTER_CHANGE
      filter: query

  toggleBucket: (bucketId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.TRANSFORMATION_BUCKETS_TOGGLE
      bucketId: bucketId

  startTransformationFieldEdit: (bucketId, transformationId, fieldId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.TRANSFORMATION_START_EDIT_FIELD
      bucketId: bucketId
      transformationId: transformationId
      fieldId: fieldId

  updateTransformationEditingField: (bucketId, transformationId, fieldId, newValue) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.TRANSFORMATION_UPDATE_EDITING_FIELD
      bucketId: bucketId
      transformationId: transformationId
      fieldId: fieldId
      newValue: newValue

  cancelTransformationEditingField: (bucketId, transformationId, fieldId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.TRANSFORMATION_CANCEL_EDITING_FIELD
      bucketId: bucketId
      transformationId: transformationId
      fieldId: fieldId

  saveTransformationEditingField: (bucketId, transformationId, fieldId) ->
    value = TransformationsStore.getTransformationEditingFields(bucketId, transformationId).get(fieldId)

    pendingAction = "save-#{fieldId}"
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_START
      transformationId: transformationId
      bucketId: bucketId
      pendingAction: pendingAction
    )

    transformation = TransformationsStore.getTransformation(bucketId, transformationId)
    if fieldId == 'queriesString'
      transformation = transformation.set 'queries', parseQueries(transformation, value)
    else
      transformation = transformation.set fieldId, value

    transformationsApi
    .saveTransformation(bucketId, transformationId, transformation.toJS())
    .then (response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_SUCCESS
        transformationId: transformationId
        bucketId: bucketId
        editingId: fieldId
        pendingAction: pendingAction
        data: response
      )
      VersionActionCreators.loadVersionsForce('transformation', bucketId)
    .catch (error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_ERROR
        transformationId: transformationId
        bucketId: bucketId
        editingId: fieldId
        pendingAction: pendingAction
        error: error
      )
      throw error

  ###
    Create new or update existing output mapping
  ###
  saveTransformationMapping: (bucketId, transformationId, mappingType, editingId, mappingIndex = null) ->
    mapping = TransformationsStore.getTransformationEditingFields(bucketId, transformationId).get(editingId)
    transformation = TransformationsStore.getTransformation(bucketId, transformationId)

    transformation = transformation.update mappingType, (mappings) ->
      if mappingIndex != null
        mappings.set mappingIndex, mapping
      else
        mappings.push mapping
    return Promise.resolve() if not mapping
    transformationsApi
    .saveTransformation(bucketId, transformationId, transformation.toJS())
    .then (response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_SUCCESS
        transformationId: transformationId
        bucketId: bucketId
        editingId: editingId
        data: response
      )
      VersionActionCreators.loadVersionsForce('transformation', bucketId)
    .catch (error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_ERROR
        transformationId: transformationId
        bucketId: bucketId
        error: error
      )
      throw error

  deleteTransformationMapping: (bucketId, transformationId, mappingType, mappingIndex) ->
    transformation = TransformationsStore.getTransformation(bucketId, transformationId)

    transformation = transformation.update mappingType, (mappings) ->
      mappings.delete(mappingIndex)

    pendingAction = "delete-#{mappingType}-#{mappingIndex}"
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_START
      transformationId: transformationId
      bucketId: bucketId
      pendingAction: pendingAction
    )

    transformationsApi
    .saveTransformation(bucketId, transformationId, transformation.toJS())
    .then (response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_SUCCESS
        transformationId: transformationId
        bucketId: bucketId
        data: response
        pendingAction: pendingAction
      )
      VersionActionCreators.loadVersionsForce('transformation', bucketId)
    .catch (error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_ERROR
        transformationId: transformationId
        bucketId: bucketId
        pendingAction: pendingAction
        error: error
      )
      throw error

  ###
    Create new or update existing output mapping
  ###
  saveSnowflakeConnection: (bucketId, transformationId) ->
    value = TransformationsStore.getTransformationEditingFields(bucketId, transformationId).get("snowflake")
    transformation = TransformationsStore.getTransformation(bucketId, transformationId)

    transformation = transformation.set "snowflake", value
    transformationsApi
    .saveTransformation(bucketId, transformationId, transformation.toJS())
    .then (response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_SUCCESS
        transformationId: transformationId
        bucketId: bucketId
        editingId: "snowflake"
        data: response
      )
      VersionActionCreators.loadVersionsForce('transformation', bucketId)
    .catch (error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_ERROR
        transformationId: transformationId
        bucketId: bucketId
        error: error
      )
      throw error
