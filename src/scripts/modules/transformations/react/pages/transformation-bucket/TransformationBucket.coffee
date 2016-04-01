React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationsStore')
TransformationBucketsStore  = require('../../../stores/TransformationBucketsStore')
RoutesStore = require '../../../../../stores/RoutesStore'
TransformationRow = React.createFactory(require '../../components/TransformationRow')
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

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'row',
        div className: 'row col-md-8',
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

module.exports = TransformationBucket
