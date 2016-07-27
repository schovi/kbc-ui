React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')
Router = require 'react-router'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationsStore')
TransformationBucketsStore  = require('../../../stores/TransformationBucketsStore')
RoutesStore = require '../../../../../stores/RoutesStore'
TransformationRow = React.createFactory(require '../../components/TransformationRow')
ComponentDescription = React.createFactory(require '../../../../components/react/components/ComponentDescription')
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
TransformationActionCreators = require '../../../ActionCreators'
{Confirm} = require '../../../../../react/common/common'
NewTransformationModal = require('../../modals/NewTransformation').default
{ModalTrigger, OverlayTrigger, Tooltip} = require 'react-bootstrap'
LatestJobsStore = require('../../../../jobs/stores/LatestJobsStore')
SidebarJobs = require('../../../../components/react/components/SidebarJobs')
SidebarVersions = require('../../../../components/react/components/SidebarVersions')
VersionsStore = require('../../../../components/stores/VersionsStore')

{div, span, input, strong, form, button, h4, i, button, small, ul, li, a} = React.DOM

TransformationBucket = React.createClass
  displayName: 'TransformationBucket'
  mixins: [
    createStoreMixin(TransformationsStore, TransformationBucketsStore, LatestJobsStore, VersionsStore)
    Router.Navigation
  ]

  getStateFromStores: ->
    bucketId = RoutesStore.getCurrentRouteParam 'bucketId'
    bucketId: bucketId
    transformations: TransformationsStore.getTransformations(bucketId)
    bucket: TransformationBucketsStore.get(bucketId)
    pendingActions: TransformationsStore.getPendingActions(bucketId)
    latestJobs: LatestJobsStore.getJobs('transformation', bucketId),
    latestVersions: VersionsStore.getVersions('transformation', bucketId),

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  render: ->
    state = @state
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div className: 'row',
            ComponentDescription
              componentId: 'transformation'
              configId: @state.bucket.get 'id'
        if @state.transformations.count()
          @_renderTable()
        else
          @_renderEmptyState()

      div className: 'col-md-3 kbc-main-sidebar',
        div className: 'kbc-buttons kbc-text-light',
          React.createElement ComponentMetadata,
            componentId: 'transformation'
            configId: @state.bucketId
        ul className: 'nav nav-stacked',
          li {},
            React.createElement ModalTrigger,
              modal: React.createElement(NewTransformationModal,
                bucket: @state.bucket
              )
              ,
                a
                  onClick: (e) ->
                    e.stopPropagation()
                    e.preventDefault()
                ,
                  span className: 'fa fa-plus fa-fw'
                  ' Add transformation'

          li {},
            RunComponentButton(
              title: 'Run transformations'
              tooltip: 'Run all transformations in bucket'
              component: 'transformation'
              mode: 'link'
              runParams: =>
                configBucketId: @state.bucketId
            ,
              "You are about to run all transformations in bucket #{@state.bucket.get('name')}."
            )
          li {},
            a {},
              React.createElement Confirm,
                title: 'Delete Bucket'
                text: "Do you really want to delete bucket #{@state.bucket.get('name')} and all transformations?"
                buttonLabel: 'Delete'
                buttonType: 'danger'
                onConfirm: @_deleteTransformationBucket
              ,
                span {},
                  span className: 'fa kbc-icon-cup fa-fw'
                  ' Delete bucket'
        React.createElement SidebarJobs,
          jobs: @state.latestJobs
          limit: 3
        React.createElement SidebarVersions,
          versions: @state.latestVersions
          bucketId: @state.bucketId
          limit: 3


  _renderTable: ->
    div className: 'table table-striped table-hover',
      span {className: 'tbody'},
        @_getSortedTransformations().map((transformation) ->
          TransformationRow
            transformation: transformation
            bucket: @state.bucket
            pendingActions: @state.pendingActions.get transformation.get('id'), Immutable.Map()
            key: transformation.get 'id'
        , @).toArray()

  _getSortedTransformations: ->
    sorted = @state.transformations.sortBy((transformation) ->
      # phase with padding
      phase = ("0000" + transformation.get('phase')).slice(-4)
      name = transformation.get('name')
      phase + name.toLowerCase()
    )
    return sorted

  _renderEmptyState: ->
    div {className: 'table table-striped'},
      div {className: 'tfoot'},
        div {className: 'tr'},
          div {className: 'td'}, 'No transformations found'

  _deleteTransformationBucket: ->
    bucketId = @state.bucket.get('id')
    TransformationActionCreators.deleteTransformationBucket(bucketId)
    @transitionTo 'transformations'



module.exports = TransformationBucket
