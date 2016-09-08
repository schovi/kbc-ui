React = require 'react'

{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{span, button, strong, div} = React.DOM
{Check, Loader} = require 'kbc-react-components'
Link = React.createFactory(require('react-router').Link)

dockerProxyApi = require('../../../templates/dockerProxyApi').default

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))
SapiTableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx').default)

{span, div, a, button, i, strong} = React.DOM

module.exports = React.createClass

  displayName: 'WrDbTableRow'
  mixins: [ImmutableRenderMixin]

  propTypes:
    tableExists: React.PropTypes.bool.isRequired
    isTableExported: React.PropTypes.bool.isRequired
    isPending: React.PropTypes.bool.isRequired
    isV2: React.PropTypes.bool.isRequired
    onExportChangeFn: React.PropTypes.func.isRequired
    table: React.PropTypes.object.isRequired
    v2ConfigTable: React.PropTypes.object.isRequired
    tableDbName: React.PropTypes.string.isRequired
    configId: React.PropTypes.string.isRequired
    componentId: React.PropTypes.string.isRequired
    deleteTableFn: React.PropTypes.func.isRequired
    isDeleting: React.PropTypes.bool.isRequired

  render: ->
    Link
      className: 'tr'
      to: "#{@props.componentId}-table"
      params:
        config: @props.configId
        tableId: @props.table.get('id')
    ,
      span className: 'td',
        SapiTableLinkEx tableId: @props.table.get('id'),
          @props.table.get 'name'
      span className: 'td',
        @props.tableDbName
      if @props.isV2
        span className: 'td',
          React.createElement Check,
            isChecked: @props.v2ConfigTable.get('incremental')
      span {className: 'td text-right'},
        @_renderDeleteButton()
        React.createElement ActivateDeactivateButton,
          activateTooltip: 'Select table to upload'
          deactivateTooltip: 'Deselect table from upload'
          isActive: @props.isTableExported
          isPending: @props.isPending
          onChange: @props.onExportChangeFn
        if @props.tableExists
          React.createElement Tooltip,
            tooltip: 'Upload table to Dropbox'
          ,
            RunButtonModal
              title: "Upload #{@props.table.get('id')}"
              tooltip: "Upload #{@props.table.get('id')}"
              mode: 'button'
              icon: 'fa fa-upload fa-fw'
              component: @props.componentId
              runParams: =>
                tableId = @props.table.get('id')
                configId = @props.configId
                params =
                  table: tableId
                  writer: configId
                api = dockerProxyApi(@props.componentId)
                return api?.getTableRunParams(configId, tableId) or params
            ,
             "You are about to run upload of #{@props.table.get('id')} to the database."

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
