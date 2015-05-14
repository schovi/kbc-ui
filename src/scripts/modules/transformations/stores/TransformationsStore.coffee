
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
  overviews: Map()
  loadingOverviews: Map()
  showDisabledOverviews: Map()
  openInputMappings: Map()
  openOutputMappings: Map()
  editingTransformations: Map()
  savingTransformations: Map()
  editingTransformationsData: Map()
  openEditingInputMappings: Map()
  openEditingOutputMappings: Map()

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
        phase = transformation.get('phase')
        name = transformation.get('name')
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

  getOverview: (bucketId, transformationId) ->
    _store.getIn ['overviews', bucketId, transformationId]

  isOverviewLoading: (bucketId, transformationId) ->
    !!_store.getIn ['loadingOverviews', bucketId, transformationId]

  isShowDisabledInOverview: (bucketId, transformationId) ->
    if _store.getIn(['showDisabledOverviews', bucketId, transformationId]) == true
      return true
    if _store.getIn(['showDisabledOverviews', bucketId, transformationId]) == false
      return false
    _store.getIn(['transformationsByBucketId', bucketId, transformationId, "disabled"], false)

  isInputMappingOpen: (bucketId, transformationId, index) ->
    _store.getIn(['openInputMappings', bucketId, transformationId, index], false)

  isInputMappingClosed: (bucketId, transformationId, index) ->
    _store.getIn(['openOutputMappings', bucketId, transformationId, index], false)

  getOpenInputMappings: (bucketId, transformationId) ->
    _store.getIn(['openInputMappings', bucketId, transformationId], Map())

  getOpenOutputMappings: (bucketId, transformationId) ->
    _store.getIn(['openOutputMappings', bucketId, transformationId], Map())

  isEditing: (bucketId, transformationId) ->
    _store.getIn(['editingTransformations', bucketId, transformationId], false)

  isSaving: (bucketId, transformationId) ->
    _store.getIn(['savingTransformations', bucketId, transformationId], false)

  getEditingTransformationData: (bucketId, transformationId) ->
    _store.getIn(['editingTransformationsData', bucketId, transformationId], Map())

  getOpenEditingInputMappings: (bucketId, transformationId) ->
    _store.getIn(['openEditingInputMappings', bucketId, transformationId], Map())

  getOpenEditingOutputMappings: (bucketId, transformationId) ->
    _store.getIn(['openEditingOutputMappings', bucketId, transformationId], Map())

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

    when Constants.ActionTypes.TRANSFORMATION_CREATE_SUCCESS
      _store = _store.setIn ['transformationsByBucketId', action.bucketId, action.transformation.id],
        Immutable.fromJS(action.transformation)
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_OVERVIEW_LOAD
      _store = _store.setIn ['loadingOverviews', action.bucketId, action.transformationId], true
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_OVEWVIEW_LOAD_ERROR
      _store = _store.setIn ['loadingOverviews', action.bucketId, action.transformationId], false
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_OVERVIEW_LOAD_SUCCESS
      _store = _store.withMutations((store) ->
        store = store.setIn(['overviews', action.bucketId, action.transformationId],
          Immutable.fromJS(action.model)
        )
        store = store.setIn ['loadingOverviews', action.bucketId, action.transformationId], false
      )
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_OVERVIEW_SHOW_DISABLED
      _store = _store.setIn ['showDisabledOverviews', action.bucketId, action.transformationId], action.showDisabled
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


    when Constants.ActionTypes.TRANSFORMATION_CHANGE_PROPERTY_START
      pendingAction = "change-#{action.propertyName}"
      _store = _store.setIn ['pendingActions', action.bucketId, action.transformationId, pendingAction], true
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_CHANGE_PROPERTY_SUCCESS
      pendingAction = "change-#{action.propertyName}"
      _store = _store.withMutations (store) ->
        store
        .setIn ['transformationsByBucketId', action.bucketId, action.transformationId, action.propertyName],
          action.newValue
        .removeIn ['pendingActions', action.bucketId, action.transformationId, pendingAction]
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_CHANGE_PROPERTY_ERROR
      pendingAction = "change-#{action.propertyName}"
      _store = _store.removeIn ['pendingActions', action.bucketId, action.transformationId, pendingAction]
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_INPUT_MAPPING_OPEN_TOGGLE
      if (_store.getIn(['openInputMappings', action.bucketId, action.transformationId, action.index], false))
        _store = _store.setIn(['openInputMappings', action.bucketId, action.transformationId, action.index], false)
      else
        _store = _store.setIn(['openInputMappings', action.bucketId, action.transformationId, action.index], true)
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_OUTPUT_MAPPING_OPEN_TOGGLE
      if (_store.getIn(['openOutputMappings', action.bucketId, action.transformationId, action.index], false))
        _store = _store.setIn(['openOutputMappings', action.bucketId, action.transformationId, action.index], false)
      else
        _store = _store.setIn(['openOutputMappings', action.bucketId, action.transformationId, action.index], true)
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_START
      _store = _store.withMutations (store) ->
        store = store.setIn ['editingTransformations', action.bucketId, action.transformationId], true
        transformation = TransformationsStore.getTransformation(action.bucketId, action.transformationId)
        if transformation.get("backend") == 'mysql' || transformation.get("backend") == 'redshift'
          transformation = transformation.set("queries", transformation.get("queries").join("\n\n"))
        else
          transformation = transformation.set("queries", transformation.getIn(["queries", 0]))
        store = store.setIn [
            'editingTransformationsData',
            action.bucketId,
            action.transformationId,
          ], transformation
        return store
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_CANCEL
      _store = _store.withMutations (store) ->
        store = store.setIn ['editingTransformations', action.bucketId, action.transformationId], false
        store = store.setIn ['editingTransformationsData', action.bucketId, action.transformationId, Map()]
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_START
      _store = _store.setIn ['savingTransformations', action.bucketId, action.transformationId], true
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_SUCCESS
      _store = _store.withMutations (store) ->
        store = store.setIn ['savingTransformations', action.bucketId, action.transformationId], false
        store = store.setIn ['editingTransformations', action.bucketId, action.transformationId], false
        store = store.setIn ['editingTransformationsData', action.bucketId, action.transformationId, Map()]
        tObj = Immutable.fromJS(action.data)
        store = store.setIn ['transformationsByBucketId', action.bucketId, action.transformationId], tObj
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_ERROR
      _store = _store.withMutations (store) ->
        store = store.setIn ['savingTransformations', action.bucketId, action.transformationId], false
        store = store.setIn ['editingTransformations', action.bucketId, action.transformationId], false
        store = store.setIn ['editingTransformationsData', action.bucketId, action.transformationId, Map()]
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_CHANGE
      _store = _store.setIn ['editingTransformationsData', action.bucketId, action.transformationId], action.data
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_INPUT_MAPPING_OPEN_TOGGLE
      if (_store.getIn(['openEditingInputMappings', action.bucketId, action.transformationId, action.index], false))
        _store = _store.setIn([
          'openEditingInputMappings',
          action.bucketId,
          action.transformationId,
          action.index
        ], false)
      else
        _store = _store.setIn([
          'openEditingInputMappings',
          action.bucketId,
          action.transformationId,
          action.index
        ], true)
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_OUTPUT_MAPPING_OPEN_TOGGLE
      if (_store.getIn([
        'openEditingOutputMappings',
        action.bucketId,
        action.transformationId,
        action.index
      ], false))
        _store = _store.setIn([
          'openEditingOutputMappings',
          action.bucketId,
          action.transformationId,
          action.index
        ], false)
      else
        _store = _store.setIn([
          'openEditingOutputMappings',
          action.bucketId,
          action.transformationId,
          action.index
        ], true)
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_INPUT_MAPPING_DELETE
      _store = _store.deleteIn [
        'editingTransformationsData',
        action.bucketId,
        action.transformationId,
        "input",
        action.index
      ]

      _store = _store.deleteIn [
        'openEditingInputMappings',
        action.bucketId,
        action.transformationId,
        action.index
      ]

      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_INPUT_MAPPING_ADD
      _store = _store.withMutations (store) ->
        inputs = store.getIn ['editingTransformationsData', action.bucketId, action.transformationId, "input"], List()
        inputs = inputs.push(new Map())
        store = store.setIn ['editingTransformationsData', action.bucketId, action.transformationId, "input"], inputs
        store = store.setIn [
          'openEditingInputMappings',
          action.bucketId,
          action.transformationId,
          inputs.count() - 1
        ], true
      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_OUTPUT_MAPPING_DELETE
      _store = _store.deleteIn [
        'editingTransformationsData',
        action.bucketId,
        action.transformationId,
        "output",
        action.index
      ]

      _store = _store.deleteIn [
        'openEditingOutputMappings',
        action.bucketId,
        action.transformationId,
        action.index
      ]

      TransformationsStore.emitChange()

    when Constants.ActionTypes.TRANSFORMATION_EDIT_OUTPUT_MAPPING_ADD
      _store = _store.withMutations (store) ->
        inputs = store.getIn ['editingTransformationsData', action.bucketId, action.transformationId, "output"], List()
        inputs = inputs.push(new Map())
        store = store.setIn ['editingTransformationsData', action.bucketId, action.transformationId, "output"], inputs
        store = store.setIn [
          'openEditingOutputMappings',
          action.bucketId,
          action.transformationId,
          inputs.count() - 1
        ], true
      TransformationsStore.emitChange()


module.exports = TransformationsStore
