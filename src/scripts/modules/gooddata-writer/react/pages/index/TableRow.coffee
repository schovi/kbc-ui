React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
Link = React.createFactory(require('react-router').Link)
ActivateTableExportButton = require('../../components/ActivateTableExportButton').default
{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{Loader} = require 'kbc-react-components'
SapiTableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx').default)

actionCreators = require '../../../actionCreators'

{span, div, a, button, i, strong} = React.DOM

module.exports = React.createClass
  displayName: 'TableRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    table: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired
    sapiTable: React.PropTypes.object.isRequired #SAPI representation of table
    deleteTableFn: React.PropTypes.func
    isDeleting: React.PropTypes.bool
    isDeleted: React.PropTypes.bool

  render: ->
    titleClass = 'td'
    if not @props.table.getIn(['data', 'export'])
      titleClass = 'td text-muted'
    elem = if @props.isDeleted then div else Link
    elem
      className: 'tr'
      to: 'gooddata-writer-table'
      params:
        config: @props.configId
        table: @props.table.get 'id'
    ,
      span className: 'td',
        SapiTableLinkEx
          tableId: @props.table.get 'id'
          linkLabel: @props.sapiTable.get('name')

      span className: titleClass,
        @props.table.getIn ['data', 'title']
      if @props.isDeleted
        span className: 'td text-right',
          @_renderDeleteButton()
      else
        span className: 'td text-right',
          React.createElement ActivateTableExportButton,
            configId: @props.configId
            table: @props.table
          @_renderDeleteButton()
          if @props.table.get('pendingActions').contains 'uploadTable'
            React.DOM.span className: 'btn btn-link',
              React.createElement Loader, className: 'fa-fw'
          else
            React.createElement Tooltip,
              tooltip: 'Upload table to GoodData'
            ,
              React.createElement Confirm,
                text: @_uploadText()
                title: 'Upload Table'
                buttonLabel: 'Upload'
                buttonType: 'success'
                onConfirm: @_handleUpload
              ,
                button className: 'btn btn-link',
                  span className: 'fa fa-upload fa-fw'

  _uploadText: ->
    span null,
      'Are you sure you want to upload table '
      strong null, @props.table.getIn(['data', 'name'])
      ' to GoodData project?'

  _renderDeleteButton: ->
    if @props.isDeleting
      span className: 'btn btn-link',
        React.createElement Loader
    else
      React.createElement Tooltip,
        tooltip: 'Remove table from configuration'
        placement: 'top'
        React.createElement Confirm,
          key: @props.table.get 'id'
          title: "Remove #{@props.table.get('id')}"
          text: 'You are about to remove table from the configuration.'
          buttonLabel: 'Remove'
          onConfirm: =>
            @props.deleteTableFn(@props.table.get('id'))
        ,
          button className: 'btn btn-link',
            i className: 'kbc-icon-cup'


  _handleUpload: ->
    actionCreators.uploadToGoodData(@props.configId, @props.table.get('id'))

  _handleExportChange: (newExportStatus) ->
    actionCreators.saveTableField(@props.configId, @props.table.get('id'), 'export', newExportStatus)
