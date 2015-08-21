React = require 'react'

Link = React.createFactory(require('react-router').Link)
{ModalTrigger, OverlayTrigger, Tooltip} = require 'react-bootstrap'
{button, i,a, strong, span, div, p, ul, li} = React.DOM
{Confirm} = require '../../../../../react/common/common'
date = require '../../../../../utils/date'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))

module.exports = React.createClass
  displayName: 'tablerowtde'

  propTypes:
    table: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired
    tdeFile: React.PropTypes.object

  render: ->
    div className: 'tr',
      span className: 'td',
        @props.table.get 'name'
      span className: 'td',
        if @props.tdeFile
          React.createElement OverlayTrigger,
            overlay: React.createElement Tooltip,
              null
            ,
              date.format @props.tdeFile.get('created')
            placement: 'top'
          ,
            a href: @props.tdeFile.get('url'),
              @props.tdeFile.get('name')
        else
          span className: 'td', 'N/A'

      # ACTION BUTTONS
      span className: 'td text-right kbc-no-wrap',
        if not @props.isDeleted
          React.createElement OverlayTrigger,
            overlay: React.createElement Tooltip, null, 'Edit table configuration'
            placement: 'top'
          ,
            Link
              className: 'btn btn-link'
              to: "tde-exporter-table"
              params:
                config: @props.configId
                tableId: @props.table.get('id')
            ,
              i className: 'fa fa-fw kbc-icon-pencil'
        React.createElement OverlayTrigger,
          overlay: React.createElement Tooltip, null, 'Delete table from configuration'
          placement: 'top'
        ,
          React.createElement Confirm,
            key: @props.table.get 'id'
            title: 'Remove table configuration.'
            text: 'You are about to remove table from the writer configuration.'
            buttonLabel: 'Remove'
            onConfirm: =>
              rowId = @props.file.get('id')
              @props.deleteRowFn(rowId)
          ,
            button className: 'btn btn-link',
              i className: 'kbc-icon-cup'
        if not @props.isDeleted
          @_renderRunButton()

  _renderRunButton: ->
    React.createElement OverlayTrigger,
      overlay: React.createElement Tooltip, null, 'Export to TDE File'
      placement: 'top'
    ,
      RunButtonModal
        title: "Export #{@props.table.get('id')} to TDE"
        tooltip: "Export #{@props.table.get('id')} to TDE"
        mode: 'button'
        component: 'wr-google-drive'
        runParams: =>
          file: @props.file.get 'id'
          config: @props.configId
      ,
       "You are about to run export of #{@props.table.get('id')} to TDE."
