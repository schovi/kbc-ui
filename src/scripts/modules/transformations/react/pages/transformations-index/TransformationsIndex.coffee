React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

TransformationBucketRow = React.createFactory(require './TransformationBucketRow')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationBucketsStore = require('../../../stores/TransformationBucketsStore')
InstalledComponentsStore = require('../../../../components/stores/InstalledComponentsStore')

{div, span, input, strong, form, button, h4, i, button, small, ul, li, a} = React.DOM
TransformationsIndex = React.createClass
  displayName: 'TransformationsIndex'
  mixins: [createStoreMixin(TransformationBucketsStore, InstalledComponentsStore)]

  getStateFromStores: ->
    buckets: TransformationBucketsStore.getAll()
    pendingActions: TransformationBucketsStore.getPendingActions()

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      if @state.buckets.count()
        @_renderTable()
      else
        @_renderEmptyState()

  _renderTable: ->
    div className: 'table table-striped table-hover',
      span {className: 'tbody'},
        @state.buckets.map((bucket) ->
          TransformationBucketRow
            bucket: bucket
            description: InstalledComponentsStore.getConfig('transformation', bucket.get('id')).get 'description'
            pendingActions: @state.pendingActions.get(bucket.get('id'), Immutable.Map())
            key: bucket.get 'id'
        , @).toArray()

  _renderEmptyState: ->
    div {className: 'table table-striped'},
      div {className: 'tfoot'},
        div {className: 'tr'},
          div {className: 'td'}, 'No transformation buckets found'

module.exports = TransformationsIndex
