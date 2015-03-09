React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationsStore')
TransformationBucketsStore  = require('../../../stores/TransformationBucketsStore')
RoutesStore = require '../../../../../stores/RoutesStore'
TransformationRow = React.createFactory(require './TransformationRow')
ComponentDescription = React.createFactory(require '../../../../components/react/components/ComponentDescription')
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

{div, span, input, strong, form, button, h4, i, button, small} = React.DOM

TransformationBucket = React.createClass
  displayName: 'TransformationBucket'
  mixins: [createStoreMixin(TransformationsStore, TransformationBucketsStore)]

  getStateFromStores: ->
    bucketId = RoutesStore.getCurrentRouteParam 'bucketId'
    transformations: TransformationsStore.getTransformations(bucketId)
    bucket: TransformationBucketsStore.get(bucketId)
    pendingActions: TransformationsStore.getPendingActions(bucketId)

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-header',
        ComponentDescription
          componentId: 'transformation'
          configId: @state.bucket.get 'id'
      if @state.transformations.count()
        @_renderTable()
      else
        @_renderEmptyState()

  _renderTable: ->
    div className: 'table table-striped table-hover',
      span {className: 'tbody'},
        @state.transformations.map((transformation) ->
          TransformationRow
            transformation: transformation
            bucket: @state.bucket
            pendingActions: @state.pendingActions.getIn [transformation.get('id')], Immutable.Map()
            key: transformation.get 'id'
        , @).toArray()

  _renderEmptyState: ->
    div {className: 'table table-striped'},
      div {className: 'tfoot'},
        div {className: 'tr'},
          div {className: 'td'}, 'No transformations found'

module.exports = TransformationBucket
