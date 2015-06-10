React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

TransformationBucketRow = React.createFactory(require './TransformationBucketRow')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationBucketsStore = require('../../../stores/TransformationBucketsStore')
InstalledComponentsStore = require('../../../../components/stores/InstalledComponentsStore')

NewTransformationBucketButton = require '../../components/NewTransformationBucketButton'

{div, span, input, strong, form, button, h4, h2, i, button, small, ul, li, a, p} = React.DOM
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
            pendingActions: @state.pendingActions.get bucket.get('id'), Immutable.Map()
            key: bucket.get 'id'
        , @).toArray()

  _renderEmptyState: ->
    div className: 'row',
      h2 null,
        'Transformations allows you to modify your data.'
      p null,
        'It picks data from Storage,
          manipulates it and then stores it back. Transformations can use MySQL, Redshift or R.'
      p null,
        React.createElement NewTransformationBucketButton,
          buttonLabel: 'Get Started Now'

module.exports = TransformationsIndex
