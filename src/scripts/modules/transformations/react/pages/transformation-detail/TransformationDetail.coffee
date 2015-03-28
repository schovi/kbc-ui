React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'

TransformationDetailStatic = React.createFactory(require './TransformationDetailStatic')
TransformationDetailEdit = React.createFactory(require './TransformationDetailEdit')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationsStore')
TransformationBucketsStore  = require('../../../stores/TransformationBucketsStore')
StorageTablesStore  = require('../../../../components/stores/StorageTablesStore')
RoutesStore = require '../../../../../stores/RoutesStore'
TransformationsActionCreators = require '../../../ActionCreators'
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
ActivateDeactivateButton = React.createFactory(require '../../../../../react/common/ActivateDeactivateButton')
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'
ConfigureTransformationSandbox = require '../../components/ConfigureTransformationSandbox'
SqlDepModalTrigger = require '../../modals/SqlDepModalTrigger.coffee'
EditButtons = React.createFactory(require('../../../../../react/common/EditButtons'))

{div, span, ul, li, a, em} = React.DOM

TransformationDetail = React.createClass
  displayName: 'TransformationDetail'

  mixins: [
    createStoreMixin(TransformationsStore, TransformationBucketsStore, StorageTablesStore),
    Router.Navigation
  ]

  getStateFromStores: ->
    bucketId = RoutesStore.getCurrentRouteParam 'bucketId'
    transformationId = RoutesStore.getCurrentRouteParam 'transformationId'
    bucket: TransformationBucketsStore.get(bucketId)
    transformation: TransformationsStore.getTransformation(bucketId, transformationId)
    pendingActions: TransformationsStore.getPendingActions(bucketId)
    tables: StorageTablesStore.getAll()
    bucketId: bucketId
    transformationId: transformationId
    openInputMappings: TransformationsStore.getOpenInputMappings(bucketId, transformationId)
    openOutputMappings: TransformationsStore.getOpenOutputMappings(bucketId, transformationId)
    isEditing: TransformationsStore.isEditing(bucketId, transformationId)
    isSaving: TransformationsStore.isSaving(bucketId, transformationId)
    editValue: TransformationsStore.getEditingTransformationData(bucketId, transformationId)
    transformations: TransformationsStore.getTransformations(bucketId)

  _handleEditStart: ->
    TransformationsActionCreators.startTransformationEdit(@state.bucketId, @state.transformationId)

  _handleEditSave: ->
    TransformationsActionCreators.saveTransformationEdit(@state.bucketId, @state.transformationId)

  _handleEditCancel: ->
    TransformationsActionCreators.cancelTransformationEdit(@state.bucketId, @state.transformationId)

  _deleteTransformation: ->
    transformationId = @state.transformation.get('id')
    bucketId = @state.bucket.get('id')
    TransformationsActionCreators.deleteTransformation(bucketId, transformationId)
    @transitionTo 'transformationBucket',
      bucketId: bucketId

  _handleEditChange: (data) ->
    TransformationsActionCreators.updateTransformationEdit(@state.bucketId, @state.transformationId, data)

  render: ->
    component = @
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div {className: 'text-right'},
          EditButtons
            isEditing: @state.isEditing
            isSaving: @state.isSaving
            isDisabled: false
            onCancel: @_handleEditCancel
            onSave: @_handleEditSave
            onEditStart: @_handleEditStart
            editLabel: 'Edit transformation'
        div {},
          if (!@state.isEditing)
            TransformationDetailStatic
              bucket: @state.bucket
              transformation: @state.transformation
              pendingActions: @state.pendingActions
              tables: @state.tables
              bucketId: @state.bucketId
              transformationId: @state.transformationId
              openInputMappings: @state.openInputMappings
              openOutputMappings: @state.openOutputMappings
          else
            TransformationDetailEdit
              transformations: @state.transformations
              transformation: @state.editValue
              tables: @state.tables
              isSaving: @state.isSaving
              onChange: @_handleEditChange

      div className: 'col-md-3 kbc-main-sidebar',
        ul className: 'nav nav-stacked',
          li {},
            RunComponentButton(
              title: "Run Transformation"
              component: 'transformation'
              mode: 'link'
              runParams: ->
                configBucketId: props.bucket.get('id')
                transformations: [props.transformation.get('id')]
            ,
              "You are about to run transformation #{@state.transformation.get('name')}."
            )
          li {},
            ActivateDeactivateButton
              mode: 'link'
              activateTooltip: 'Enable Transformation'
              deactivateTooltip: 'Disable Transformation'
              isActive: !parseInt(@state.transformation.get('disabled'))
              isPending: @state.pendingActions.get('save')
              onChange: ->
          li {},
            RunComponentButton(
              icon: 'fa-wrench'
              title: "Create Sandbox"
              component: 'transformation'
              method: 'run'
              mode: 'link'
              runParams: ->
                sandboxConfiguration
            ,
              ConfigureTransformationSandbox
                bucketId: @state.bucketId
                transformationId: @state.transformationId
                onChange: (params) ->
                  sandboxConfiguration = params
            )

          if @state.transformation.get('backend') == 'redshift' or
              @state.transformation.get('backend') == 'mysql' && @state.transformation.get('type') == 'simple'
            li {},
              SqlDepModalTrigger
                backend: @state.transformation.get('backend')
                bucketId: @state.bucketId
                transformationId: @state.transformationId
              ,
                a {},
                  span className: 'fa fa-sitemap fa-fw'
                  ' SQLDep'

          li {},
            a {},
              Confirm
                text: 'Delete Transformation'
                title: "Do you really want to delete transformation #{@state.transformation.get('name')}?"
                buttonLabel: 'Delete'
                buttonType: 'danger'
                onConfirm: @_deleteTransformation
              ,
                span {},
                  span className: 'fa kbc-icon-cup fa-fw'
                  ' Delete transformation'

module.exports = TransformationDetail
