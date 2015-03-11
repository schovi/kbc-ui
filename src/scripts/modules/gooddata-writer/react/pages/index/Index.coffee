React = require 'react'
{List} = require 'immutable'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentDescription = React.createFactory(require '../../../../components/react/components/ComponentDescription')

{Panel, PanelGroup, Alert} = require('react-bootstrap')
Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup
Alert = React.createFactory Alert

TablesList = React.createFactory(require './BucketTablesList')
ActiveCountBadge = React.createFactory(require './ActiveCountBadge')
Link = React.createFactory(require('react-router').Link)
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'

goodDataWriterStore = require '../../../store'
actionCreators = require '../../../actionCreators'

{strong, br, ul, li, div, span, i, a, button} = React.DOM

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
        if writer.get 'info'
          Alert bsStyle: 'warning',
            writer.get 'info'
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
          li null,
            Confirm
              text: 'Upload project'
              title: 'Are you sure you want to upload all tables to GoodData project?'
              buttonLabel: 'Upload'
              buttonType: 'success'
              onConfirm: @_handleProjectUpload
            ,
              a null,
                span className: 'fa fa-upload fa-fw'
                ' Upload project'
            if @state.writer.get('pendingActions', List()).contains 'uploadProject'
              span null,
                ' '
                React.createElement Loader
          li null,
            Link
              to: 'gooddata-writer-model'
              params:
                config: @state.writer.getIn ['config', 'id']
            ,
              span className: 'fa fa-sitemap fa-fw'
              ' Model'
          li null,
            Confirm
              title: 'Delete Writer'
              text: "Are you sure you want to delete writer with its GoodData project?"
              buttonLabel: 'Delete'
              onConfirm: @_handleProjectDelete
            ,
              a null,
                span className: 'kbc-icon-cup'
                ' Delete Writer'
            if @state.writer.get 'isDeleting'
              span null,
                ' '
                React.createElement Loader

  _handleProjectUpload: ->
    actionCreators.uploadToGoodData(@state.writer.getIn ['config', 'id'])

  _handleProjectDelete: ->
    actionCreators.deleteWriter(@state.writer.getIn ['config', 'id'])

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
