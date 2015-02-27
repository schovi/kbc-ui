React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentDescription = React.createFactory(require '../../../../components/react/components/ComponentDescription')

{Panel, PanelGroup} = require('react-bootstrap')
Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup

TablesList = React.createFactory(require './BucketTablesList')
ActiveCountBadge = React.createFactory(require './ActiveCountBadge')

goodDataWriterStore = require '../../../store'

{strong, br, ul, li, div, span, i} = React.DOM

module.exports = React.createClass
  displayName: 'GooddDataWriterIndex'
  mixins: [createStoreMixin(goodDataWriterStore)]

  getStateFromStores: ->
    config =  RoutesStore.getCurrentRouteParam('config')
    writer: goodDataWriterStore.getWriter(config)
    tablesByBucket: goodDataWriterStore.getWriterTablesByBucket(config)

  render: ->
    console.log 'writer', @state.writer.toJS(), @state.tablesByBucket.toJS()
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div className: 'row kbc-header',
          div className: 'col-sm-8',
            ComponentDescription
              componentId: 'gooddata-writer'
              configId: @state.writer.getIn ['config', 'id']
          div className: 'col-sm-4 kbc-buttons',
        PanelGroup accordion: true,
          @state.tablesByBucket.map (tables, bucketId) ->
            @_renderBucketPanel bucketId, tables
          , @
          .toArray()

      div className: 'col-md-3 kbc-main-sidebar',
        'TODO'

  _renderBucketPanel: (bucketId, tables) ->

    activeCount = tables.filter((table) -> table.getIn(['data', 'export'])).count()

    header = span null,
      span className: 'table',
        span className: 'tbody',
          span className: 'tr',
            span className: 'td',
              bucketId
            span className: 'td text-right',
              ActiveCountBadge
                totalCount: tables.size
                activeCount: activeCount

    Panel
      header: header
      key: bucketId
      eventKey: bucketId
    ,
      TablesList
        configId: @state.writer.getIn ['config', 'id']
        tables: tables