React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationsStore')
TransformationBucketsStore  = require('../../../stores/TransformationBucketsStore')
StorageTablesStore  = require('../../../../components/stores/StorageTablesStore')
RoutesStore = require '../../../../../stores/RoutesStore'
DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')
TransformationsActionCreators = require '../../../ActionCreators'
InputMappingRow = React.createFactory(require './InputMappingRow')
OutputMappingRow = React.createFactory(require './OutputMappingRow')

{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'

{div, span, input, strong, form, button, h4, i, ul, li, button, a, small, p} = React.DOM

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

  render: ->
    console.log 'transformation', @state.transformation, @state.tables
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div className: 'row kbc-header',
          @state.transformation.get 'description'
          #TransformationDescription
          #  bucketId: @state.bucket.get 'id'
          #  transformation: @state.transformation.get 'id'
        div className: 'row',
          h4 {}, 'Overview'
        div className: 'row',
          h4 {}, 'Input Mapping'
            if @state.transformation.get('input').count()
              div className: 'table table-striped table-hover',
                span {className: 'tbody'},
                  @state.transformation.get('input').map((input) ->
                    InputMappingRow
                      transformationBackend: @state.transformation.get('backend')
                      inputMapping: input,
                      tables: @state.tables
                  , @).toArray()
            else
              p {}, small {}, 'No Input Mapping'
        div className: 'row',
          h4 {}, 'Output Mapping'
            if @state.transformation.get('output').count()
              div className: 'table table-striped table-hover',
                span {className: 'tbody'},
                  @state.transformation.get('output').map((output) ->
                    OutputMappingRow
                      outputMapping: output,
                      tables: @state.tables
                  , @).toArray()
            else
              p {}, small {}, 'No Output Mapping'
        div className: 'row',
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
