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
ConfigureTransformationSandboxMode = React.createFactory(require '../../components/ConfigureTransformationSandboxMode')
SqlDepModalTrigger = React.createFactory(require '../../modals/SqlDepModalTrigger.coffee')
EditButtons = React.createFactory(require('../../../../../react/common/EditButtons'))


{div, span, ul, li, a, em} = React.DOM

TransformationDetail = React.createClass
  displayName: 'TransformationDetail'

  mixins: [
    createStoreMixin(TransformationsStore, TransformationBucketsStore, StorageTablesStore),
    Router.Navigation
  ]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

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
    openEditingInputMappings: TransformationsStore.getOpenEditingInputMappings(bucketId, transformationId)
    openEditingOutputMappings: TransformationsStore.getOpenEditingOutputMappings(bucketId, transformationId)
    isEditing: TransformationsStore.isEditing(bucketId, transformationId)
    isSaving: TransformationsStore.isSaving(bucketId, transformationId)
    editValue: TransformationsStore.getEditingTransformationData(bucketId, transformationId)
    transformations: TransformationsStore.getTransformations(bucketId)

  getInitialState: ->
    sandboxMode: 'prepare'

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

  _handleActiveChange: (newValue) ->
    TransformationsActionCreators.changeTransformationProperty(@state.bucketId,
      @state.transformationId, 'disabled', !newValue)

  _showDetails: ->
    @state.transformation.get('backend') == 'mysql' and @state.transformation.get('type') == 'simple' or
    @state.transformation.get('backend') == 'redshift' and @state.transformation.get('type') == 'simple' or
    @state.transformation.get('backend') == 'docker' and @state.transformation.get('type') == 'r'

  render: ->
    component = @
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div {},
          if (!@state.isEditing)
            TransformationDetailStatic
              bucket: @state.bucket
              transformation: @state.transformation
              transformations: @state.transformations
              pendingActions: @state.pendingActions
              tables: @state.tables
              bucketId: @state.bucketId
              transformationId: @state.transformationId
              openInputMappings: @state.openInputMappings
              openOutputMappings: @state.openOutputMappings
              showDetails: @_showDetails()
          else
            TransformationDetailEdit
              transformations: @state.transformations
              transformation: @state.editValue
              tables: @state.tables
              isSaving: @state.isSaving
              onChange: @_handleEditChange
              openInputMappings: @state.openEditingInputMappings
              openOutputMappings: @state.openEditingOutputMappings
              onAddInputMapping: ->
                TransformationsActionCreators.addInputMapping(
                  component.state.bucketId,
                  component.state.transformationId
                )
              onDeleteInputMapping: (key) ->
                TransformationsActionCreators.deleteInputMapping(
                  component.state.bucketId,
                  component.state.transformationId,
                  key
                )
              toggleOpenInputMapping: (key) ->
                TransformationsActionCreators.toggleOpenEditingInputMapping(
                  component.state.bucketId,
                  component.state.transformationId,
                  key
                )
              onAddOutputMapping: ->
                TransformationsActionCreators.addOutputMapping(
                  component.state.bucketId,
                  component.state.transformationId
                )
              onDeleteOutputMapping: (key) ->
                TransformationsActionCreators.deleteOutputMapping(
                  component.state.bucketId,
                  component.state.transformationId,
                  key
                )
              toggleOpenOutputMapping: (key) ->
                TransformationsActionCreators.toggleOpenEditingOutputMapping(
                  component.state.bucketId,
                  component.state.transformationId,
                  key
                )


      div className: 'col-md-3 kbc-main-sidebar',
        ul className: 'nav nav-stacked',
          li {},
            Link
              to: 'transformationDetailGraph'
              params: {transformationId: @state.transformation.get("id"), bucketId: @state.bucket.get('id')}
            ,
              span className: 'fa fa-search fa-fw'
              ' Overview'
          li {},
            RunComponentButton(
              title: "Run transformation"
              component: 'transformation'
              mode: 'link'
              runParams: =>
                configBucketId: @state.bucketId
                transformations: [@state.transformation.get('id')]
            ,
              "You are about to run transformation #{@state.transformation.get('name')}."
            )
          li {},
            ActivateDeactivateButton
              mode: 'link'
              activateTooltip: 'Enable transformation'
              deactivateTooltip: 'Disable transformation'
              isActive: !@state.transformation.get('disabled')
              isPending: @state.pendingActions.hasIn [@state.transformation.get('id'), 'change-disabled']
              onChange: @_handleActiveChange
          li {},
            RunComponentButton(
              icon: 'fa-wrench'
              title: "Create sandbox"
              component: 'transformation'
              method: 'run'
              mode: 'link'
              runParams: =>
                configBucketId: @state.bucketId
                transformations: [@state.transformationId]
                mode: @state.sandboxMode
            ,
              ConfigureTransformationSandboxMode
                mode: @state.sandboxMode
                onChange: (mode) =>
                  @setState
                    sandboxMode: mode
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
              React.createElement Confirm,
                text: 'Delete transformation'
                title: "Do you really want to delete transformation #{@state.transformation.get('name')}?"
                buttonLabel: 'Delete'
                buttonType: 'danger'
                onConfirm: @_deleteTransformation
              ,
                span {},
                  span className: 'fa kbc-icon-cup fa-fw'
                  ' Delete transformation'

module.exports = TransformationDetail
