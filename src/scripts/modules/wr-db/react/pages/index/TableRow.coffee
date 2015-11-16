React = require 'react'

{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{span, button, strong, div} = React.DOM
Link = React.createFactory(require('react-router').Link)

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))
SapiTableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx').default)


module.exports = React.createClass

  displayName: 'WrDbTableRow'
  mixins: [ImmutableRenderMixin]

  propTypes:
    isTableExported: React.PropTypes.bool.isRequired
    isPending: React.PropTypes.bool.isRequired
    onExportChangeFn: React.PropTypes.func.isRequired
    table: React.PropTypes.object.isRequired
    tableDbName: React.PropTypes.string.isRequired
    configId: React.PropTypes.string.isRequired
    componentId: React.PropTypes.string.isRequired

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
      span {className: 'td text-right'},
        React.createElement ActivateDeactivateButton,
          activateTooltip: 'Select table to upload'
          deactivateTooltip: 'Deselect table from upload'
          isActive: @props.isTableExported
          isPending: @props.isPending
          onChange: @props.onExportChangeFn
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
              table: @props.table.get('id')
              writer: @props.configId
          ,
           "You are about to run upload of #{@props.table.get('id')} to the database."
