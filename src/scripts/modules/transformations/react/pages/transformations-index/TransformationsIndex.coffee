React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
TransformationBucketsStore = require('../../../stores/TransformationBucketsStore')

{div, span, input, strong, form, button, h4, i, button, small, ul, li, a} = React.DOM
TransformationsIndex = React.createClass
  displayName: 'TransformationsIndex'
  mixins: [createStoreMixin(TransformationBucketsStore)]

  getStateFromStores: ->
    buckets: TransformationBucketsStore.getAll()

  render: ->
    div {className: 'container-fluid'},
      div {className: 'col-md-9 kbc-main-content'},
        @_renderTable()
      div {className: 'col-md-3 kbc-main-sidebar'},
        @_renderSidebar()

  _renderSidebar: ->
    ul {className: 'nav nav-stacked'},
      li {},
        a {className: "add-bucket"},
          i {className: "fa fa-fw fa-plus"}
          "Add Bucket"
      li {},
        a {className: "sandbox"},
          i {className: "fa fa-fw fa-wrench"}
          "Create Sandbox"
      li {},
        a {className: "sandbox"},
          i {className: "fa fa-fw fa-list-ul"}
          "Sandbox Credentials"

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
    console.log 'rendering table'
    idx = 0
    span {className: 'table'},
      span {className: 'tbody'},
        @state.buckets.map((bucket) ->
          idx++
          @_renderTableRow(bucket)
          
        , @).toArray()

module.exports = TransformationsIndex
