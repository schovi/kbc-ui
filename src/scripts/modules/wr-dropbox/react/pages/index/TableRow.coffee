React = require 'react'
{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{span, button, strong, div} = React.DOM
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

module.exports = React.createClass
  displayName: 'DropboxTableRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    isTableExported: React.PropTypes.bool.isRequired
    isPending: React.PropTypes.bool.isRequired
    onExportChangeFn: React.PropTypes.func.isRequired
    onHandleUploadFn: React.PropTypes.func.isRequired
    table: React.PropTypes.object.isRequired

  render: ->
    console.log "RENDER table row"
    div {className: 'tr', key: @props.table.get('id')},
      span className: 'td',
        @props.table.get 'name'
      span className: 'td text-right',
        React.createElement ActivateDeactivateButton,
          activateTooltip: 'Select table to bulk upload'
          deactivateTooltip: 'Deselect table from bulk upload'
          isActive: @props.isTableExported
          isPending: @props.isPending
          onChange: @props.onExportChangeFn()
        React.createElement Tooltip,
          tooltip: 'Upload table to Dropbox'
        ,
          React.createElement Confirm,
            text: 'Upload Table'
            title: 'Upload Table'
            buttonLabel: 'Upload'
            buttonType: 'success'
            onConfirm: @_handleUpload
          ,
            button className: 'btn btn-link',
              span className: 'fa fa-upload fa-fw'
