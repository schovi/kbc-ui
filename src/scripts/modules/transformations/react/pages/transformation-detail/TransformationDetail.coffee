React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationsStore')
TransformationBucketsStore  = require('../../../stores/TransformationBucketsStore')
RoutesStore = require '../../../../../stores/RoutesStore'
DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')
TransformationsActionCreators = require '../../../ActionCreators'

{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'

{div, span, input, strong, form, button, h4, i, ul, li, button, a, small} = React.DOM

TransformationDetail = React.createClass
  displayName: 'TransformationDetail'
  mixins: [createStoreMixin(TransformationsStore, TransformationBucketsStore), Router.Navigation]
  getStateFromStores: ->
    bucketId = RoutesStore.getCurrentRouteParam 'bucketId'
    transformationId = RoutesStore.getCurrentRouteParam 'transformationId'
    bucket: TransformationBucketsStore.get(bucketId)
    transformation: TransformationsStore.getTransformation(bucketId, transformationId)
    pendingActions: TransformationsStore.getPendingActions(bucketId)

  render: ->
    console.log 'transformation', @state.transformation
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div className: 'row kbc-header',
          @state.transformation.get 'description'
          #TransformationDescription
          #  bucketId: @state.bucket.get 'id'
          #  transformation: @state.transformation.get 'id'
        div className: 'row',
          h4 {}, 'Overview'
          h4 {}, 'Input Mapping'
          h4 {}, 'Output Mapping'
          h4 {}, 'Queries'
      div className: 'col-md-3 kbc-main-sidebar',
        ul className: 'nav nav-stacked',
          li {},
            a {},
              span className: 'fa fa-sitemap fa-fw'
              ' SQLDep'
          li {},
            a {},
              Confirm
                text: 'Delete Transformation'
                title: "Do you really want to delete transformation #{@state.transformation.get('friendlyName')}?"
                buttonLabel: 'Delete'
                buttonType: 'danger'
                onConfirm: @_deleteTransformation
              ,
                span {},
                  span className: 'fa kbc-icon-cup fa-fw'
                  ' Delete transformation'

  _deleteTransformation: ->
    transformationId = @state.transformation.get('id')
    bucketId = @state.bucket.get('id')
    TransformationsActionCreators.deleteTransformation(bucketId, transformationId)
    @transitionTo 'transformationBucket',
      bucketId: bucketId

module.exports = TransformationDetail
