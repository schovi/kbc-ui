React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

TransformationBucketRow = React.createFactory(require './TransformationBucketRow')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
TransformationBucketsStore = require('../../../stores/TransformationBucketsStore')

{div, span, input, strong, form, button, h4, i, button, small, ul, li, a} = React.DOM
TransformationsIndex = React.createClass
  displayName: 'TransformationsIndex'
  mixins: [createStoreMixin(TransformationBucketsStore)]

  getStateFromStores: ->
    buckets: TransformationBucketsStore.getAll()
    pendingActions: TransformationBucketsStore.getPendingActions()

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      if @state.buckets.count()
        @_renderTable()
      else
        @_renderEmptyState()

  _renderTableRow: (row) ->
    Link {className: 'tr', to: 'transformationBucket', params: {bucketId: row.get('id')}},
      span {className: 'td'},
        h4 {}, row.get('name')
      span {className: 'td'},
        small {}, row.get('description')
      span {className: 'td'},
        button {className: 'btn btn-default btn-sm remove-bucket'},
          i {className: 'kbc-icon-cup'}
        button {className: 'btn btn-default btn-sm run-transformation'},
          i {className: 'fa fa-fw fa-play'}

  _renderTable: ->
    div className: 'table table-striped table-hover',
      span {className: 'tbody'},
        @state.buckets.map((bucket) ->
          TransformationBucketRow
            bucket: bucket
            pendingActions: @state.pendingActions.get(bucket.get('id'), Immutable.Map())
            key: bucket.get 'id'
        , @).toArray()

  _renderEmptyState: ->
    div {className: 'table table-striped'},
      div {className: 'tfoot'},
        div {className: 'tr'},
          div {className: 'td'}, 'No transformation buckets found'

module.exports = TransformationsIndex
