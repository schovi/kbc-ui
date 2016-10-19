React = require 'react'
{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{Loader} = require 'kbc-react-components'
{i, span, button, strong, div} = React.DOM
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))
SapiTableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx').default)

module.exports = React.createClass
  displayName: 'DropboxTableRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    deleteTableFn: React.PropTypes.func.isRequired
    isTableExported: React.PropTypes.bool.isRequired
    isPending: React.PropTypes.bool.isRequired
    prepareSingleUploadDataFn: React.PropTypes.func.isRequired
    table: React.PropTypes.object.isRequired
    mapping: React.PropTypes.object.isRequired
    onEditTable: React.PropTypes.func
    componentId: React.PropTypes.string

  render: ->
    outputName = @props.mapping.get('destination') or "#{@props.mapping.get('source')}.csv"
    div {className: 'tr', key: @props.table.get('id')},
      span className: 'td',
        SapiTableLinkEx tableId: @props.table.get('id'),
          @props.table.get 'name'
      span className: 'td',
        i className: 'kbc-icon-arrow-right'
      span className: 'td',
        outputName
      span {className: 'td text-right'},
        @_renderEditButton()
        @_renderDeleteButton()
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
              configData: @props.prepareSingleUploadDataFn(@props.table)
          ,
           "You are about to run upload of #{@props.table.get('id')} to dropbox account. \
            The resulting file will be stored into 'Apps/Keboola Writer' dropbox folder."
  _renderEditButton: ->
    React.createElement Tooltip,
      tooltip: 'Edit table mapping'
      placement: 'top'
    ,
      button
        className: 'btn btn-link'
        onClick: @props.onEditTable
      ,
        i className: 'fa fa-fw kbc-icon-pencil'

  _renderDeleteButton: ->
    if @props.isPending
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
