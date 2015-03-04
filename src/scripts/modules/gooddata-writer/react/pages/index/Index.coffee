React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentDescription = React.createFactory(require '../../../../components/react/components/ComponentDescription')

{Panel, PanelGroup} = require('react-bootstrap')
Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup

TablesList = React.createFactory(require './BucketTablesList')
ActiveCountBadge = React.createFactory(require './ActiveCountBadge')
Link = React.createFactory(require('react-router').Link)

goodDataWriterStore = require '../../../store'

{strong, br, ul, li, div, span, i, a} = React.DOM

module.exports = React.createClass
  displayName: 'GooddDataWriterIndex'
  mixins: [createStoreMixin(goodDataWriterStore)]

  getStateFromStores: ->
    config =  RoutesStore.getCurrentRouteParam('config')
    writer: goodDataWriterStore.getWriter(config)
    tablesByBucket: goodDataWriterStore.getWriterTablesByBucket(config)

  render: ->
    writer = @state.writer.get 'config'
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div className: 'row kbc-header',
          div className: 'col-sm-8',
            ComponentDescription
              componentId: 'gooddata-writer'
              configId: writer.get 'id'
          div className: 'col-sm-4 kbc-buttons',
        PanelGroup accordion: true,
          @state.tablesByBucket.map (tables, bucketId) ->
            @_renderBucketPanel bucketId, tables
          , @
          .toArray()

      div className: 'col-md-3 kbc-main-sidebar',
        ul className: 'nav nav-stacked',
          li null,
            Link
              to: 'gooddata-writer-date-dimensions'
              params:
                config: writer.get 'id'
            ,
              span className: 'fa fa-clock-o fa-fw'
              ' Date Dimensions'
          if writer.getIn(['gd', 'pid']) && !writer.get('toDelete')
            li null,
              a
                href: "https://secure.gooddata.com/#s=/gdc/projects/#{writer.getIn(['gd', 'pid'])}|dataPage|"
                target: '_blank'
              ,
                span className: 'fa fa-bar-chart-o'
                ' GoodData Project'


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