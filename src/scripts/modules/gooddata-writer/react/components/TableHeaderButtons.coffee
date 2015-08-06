React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
goodDataWriterStore = require '../../store'
actionCreators = require '../../actionCreators'
RoutesStore = require '../../../../stores/RoutesStore'
Loader = require('kbc-react-components').Loader
TableLoadType = React.createFactory(require './TableLoadType')

{ButtonGroup, Button, DropdownButton, MenuItem, Tooltip} = require 'react-bootstrap'

Confirm = require '../../../../react/common/Confirm'
PureRenderMixin = require('react/addons').addons.PureRenderMixin


{button, span, div} = React.DOM

module.exports = React.createClass
  displayName: 'GoodDataWriterTableButtons'
  mixins: [createStoreMixin(goodDataWriterStore), PureRenderMixin]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('table')

    table: goodDataWriterStore.getTable(configId, tableId)
    configurationId: configId

  _handleResetExportStatus: ->
    actionCreators.saveTableField @state.configurationId,
      @state.table.get 'id'
      'isExported'
      false

  _handleResetTable: ->
    actionCreators.resetTable @state.configurationId,
      @state.table.get 'id'

  _handleSynchronizeTable: ->
    actionCreators.synchronizeTable @state.configurationId,
      @state.table.get 'id'

  _handleUpload: ->
    actionCreators.uploadToGoodData @state.configurationId, @state.table.get('id')

  render: ->
    resetExportStatusText = React.DOM.span null,
      'Are you sure you want to reset export status of '
      React.DOM.strong null, @state.table.getIn ['data', 'name']
      ' dataset?'

    resetTableText = React.DOM.span null,
      'You are about to remove dataset in the GoodData project belonging
      to the table and reset its export status.
      Are you sure you want to reset table '
      React.DOM.strong null, @state.table.getIn ['data', 'name']
      ' ?'

    uploadTableText = React.DOM.span null,
      'Are you sure you want to upload '
      @state.table.getIn ['data', 'name']
      ' to GoodData project?'

    synchronizeTableText = React.DOM.span null,
      'Are you sure you want to execute '
      React.DOM.a
        href: 'https://developer.gooddata.com/article/maql-ddl#synchronize'
        target: '_blank'
      ,
        'synchronize'
      ' operation on '
      @state.table.getIn ['data', 'name']
      ' dataset?'

    div null,
      TableLoadType
        table: @state.table
        configurationId: @state.configurationId
      ' '
      React.createElement ButtonGroup, null,
        React.createElement DropdownButton, null,
          React.createElement MenuItem, null,
            React.createElement Confirm,
              title: 'Reset export status'
              text: resetExportStatusText
              buttonLabel: 'Reset'
              buttonType: 'success'
              onConfirm: @_handleResetExportStatus
            ,
              React.DOM.span null, 'Reset export status'
          React.createElement MenuItem, null,
            React.createElement Confirm,
              title: 'Reset table'
              text: resetTableText
              buttonLabel: 'Reset'
              buttonType: 'success'
              onConfirm: @_handleResetTable
            ,
              React.DOM.span null, 'Reset table'
          React.createElement MenuItem, null,
            React.createElement Confirm,
              title: 'Synchronize dataset'
              text: synchronizeTableText
              buttonLabel: 'Synchronize'
              buttonType: 'success'
              onConfirm: @_handleSynchronizeTable
            ,
              React.DOM.span null, 'Synchronize dataset'
        if @state.table.get('pendingActions').contains 'uploadTable'
          React.createElement Button, null,
            React.createElement Loader, className: 'fa-fw'
            ' Upload table'
        else
          React.createElement Confirm,
            text: uploadTableText
            title: 'Upload Table'
            buttonLabel: 'Upload'
            buttonType: 'success'
            onConfirm: @_handleUpload
          ,
            React.createElement Button, null,
              span className: 'fa fa-upload fa-fw'
              ' Upload table'

