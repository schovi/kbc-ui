React = require 'react'
{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{span, button, strong, div} = React.DOM
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))


module.exports = React.createClass
  displayName: 'DropboxTableRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    isTableExported: React.PropTypes.bool.isRequired
    isPending: React.PropTypes.bool.isRequired
    onExportChangeFn: React.PropTypes.func.isRequired
    prepareSingleUploadDataFn: React.PropTypes.func.isRequired
    table: React.PropTypes.object.isRequired

  render: ->
    div {className: 'tr', key: @props.table.get('id')},
      span className: 'td',
        @props.table.get 'name'
      span {className: 'td text-right'},
        React.createElement ActivateDeactivateButton,
          activateTooltip: 'Select table to upload'
          deactivateTooltip: 'Deselect table from upload'
          isActive: @props.isTableExported
          isPending: @props.isPending
          onChange: @props.onExportChangeFn()
        React.createElement Tooltip,
          tooltip: 'Upload table to Dropbox'
        ,
          RunButtonModal
            title: "Upload #{@props.table.get('id')}"
            tooltip: "Upload #{@props.table.get('id')}"
            mode: 'button'
            icon: 'fa fa-upload fa-fw'
            component: 'wr-dropbox'
            runParams: =>
              configData: @props.prepareSingleUploadDataFn(@props.table)
          ,
           "You are about to run upload of #{@props.table.get('id')} to dropbox account. \
            The resulting file will be stored into 'Apps/Keboola Writer' dropbox folder."
