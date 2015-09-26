React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require 'immutable'

TransformationDetailStatic = React.createFactory(require './TransformationDetailStatic')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationsStore')
TransformationBucketsStore  = require('../../../stores/TransformationBucketsStore')
StorageTablesStore  = require('../../../../components/stores/StorageTablesStore')
StorageBucketsStore  = require('../../../../components/stores/StorageBucketsStore')
RoutesStore = require '../../../../../stores/RoutesStore'
TransformationsActionCreators = require '../../../ActionCreators'
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
ActivateDeactivateButton = React.createFactory(require '../../../../../react/common/ActivateDeactivateButton')
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'
ConfigureTransformationSandboxMode = React.createFactory(require '../../components/ConfigureTransformationSandboxMode')
SqlDepModalTrigger = React.createFactory(require '../../modals/SqlDepModalTrigger.coffee')
EditButtons = React.createFactory(require('../../../../../react/common/EditButtons'))
ConfigureSnowflakeConnection = React.createFactory(require './ConfigureSnowflakeConnection')

{div, span, ul, li, a, em} = React.DOM

module.exports = React.createClass
  displayName: 'TransformationDetail'

  mixins: [
    createStoreMixin(TransformationsStore, TransformationBucketsStore, StorageTablesStore, StorageBucketsStore),
    Router.Navigation
  ]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    bucketId = RoutesStore.getCurrentRouteParam 'bucketId'
    transformationId = RoutesStore.getCurrentRouteParam 'transformationId'
    bucket: TransformationBucketsStore.get(bucketId)
    transformation: TransformationsStore.getTransformation(bucketId, transformationId)
    editingFields: TransformationsStore.getTransformationEditingFields(bucketId, transformationId)
    pendingActions: TransformationsStore.getTransformationPendingActions(bucketId, transformationId)
    tables: StorageTablesStore.getAll()
    buckets: StorageBucketsStore.getAll()
    bucketId: bucketId
    transformationId: transformationId
    openInputMappings: TransformationsStore.getOpenInputMappings(bucketId, transformationId)
    openOutputMappings: TransformationsStore.getOpenOutputMappings(bucketId, transformationId)
    transformations: TransformationsStore.getTransformations(bucketId)

  getInitialState: ->
    sandboxMode: 'prepare'
    sandboxRedirect: true

  _deleteTransformation: ->
    transformationId = @state.transformation.get('id')
    bucketId = @state.bucket.get('id')
    TransformationsActionCreators.deleteTransformation(bucketId, transformationId)
    @transitionTo 'transformationBucket',
      bucketId: bucketId

  _handleActiveChange: (newValue) ->
    TransformationsActionCreators.changeTransformationProperty(@state.bucketId,
      @state.transformationId, 'disabled', !newValue)

  _showDetails: ->
    @state.transformation.get('backend') == 'mysql' and @state.transformation.get('type') == 'simple' or
    @state.transformation.get('backend') == 'redshift' and @state.transformation.get('type') == 'simple' or
    @state.transformation.get('backend') == 'snowflake' and @state.transformation.get('type') == 'simple' or
    @state.transformation.get('backend') == 'docker' and @state.transformation.get('type') == 'r'

  render: ->
    console.log "snowflake", @state.editingFields.get("snowflake")
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
          TransformationDetailStatic
            bucket: @state.bucket
            transformation: @state.transformation
            editingFields: @state.editingFields
            transformations: @state.transformations
            pendingActions: @state.pendingActions
            tables: @state.tables
            buckets: @state.buckets
            bucketId: @state.bucketId
            transformationId: @state.transformationId
            openInputMappings: @state.openInputMappings
            openOutputMappings: @state.openOutputMappings
            showDetails: @_showDetails()
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
            ConfigureSnowflakeConnection
              bucket: @state.bucket
              transformation: @state.transformation
              connection: @state.editingFields.get('snowflake', Immutable.Map())
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
              isPending: @state.pendingActions.has 'change-disabled'
              onChange: @_handleActiveChange

          if @state.transformation.get('backend') == 'redshift' or
          @state.transformation.get('backend') == 'mysql' && @state.transformation.get('type') == 'simple' or
          @state.transformation.get('backend') == 'snowflake'
            li {},
              RunComponentButton(
                icon: 'fa-wrench'
                title: "Create sandbox"
                component: 'transformation'
                method: 'run'
                mode: 'link'
                redirect: @state.sandboxRedirect
                runParams: =>
                  configBucketId: @state.bucketId
                  transformations: [@state.transformationId]
                  mode: @state.sandboxMode
              ,

                ConfigureTransformationSandboxMode
                  backend: @state.transformation.get("backend")
                  mode: @state.sandboxMode
                  redirect: @state.sandboxRedirect
                  onChange: (values) =>
                    @setState
                      sandboxMode: values.mode
                      sandboxRedirect: values.redirect
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
