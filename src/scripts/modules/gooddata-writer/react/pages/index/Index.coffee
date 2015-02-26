React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentDescription = React.createFactory(require '../../../../components/react/components/ComponentDescription')

{Panel, PanelGroup} = require('react-bootstrap')
Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup

TablesList = React.createFactory(require './BucketTablesList')

goodDataWriterStore = require '../../../store'

{strong, br, ul, li, div, span, i} = React.DOM

module.exports = React.createClass
  displayName: 'GooddDataWriterIndex'
  mixins: [createStoreMixin(goodDataWriterStore)]

  getStateFromStores: ->
    config =  RoutesStore.getCurrentRouteParam('config')
    writer: goodDataWriterStore.getWriter(config)

  render: ->
    console.log 'writer', @state.writer.toJS()
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div className: 'row kbc-header',
          div className: 'col-sm-8',
            ComponentDescription
              componentId: 'gooddata-writer'
              configId: @state.writer.getIn ['config', 'id']
          div className: 'col-sm-4 kbc-buttons',
        PanelGroup accordion: true,
          @state.writer.get('tables').map (tables, bucketId) ->
            Panel
              header: bucketId
              key: bucketId
              eventKey: bucketId
            ,
              TablesList
                configId: @state.writer.getIn ['config', 'id']
                tables: tables
          , @
          .toArray()

      div className: 'col-md-3 kbc-main-sidebar',
        'TODO'
