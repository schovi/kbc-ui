React = require 'react'
_ = require 'underscore'
filesize = require 'filesize'
Link = React.createFactory(require('react-router').Link)
{ModalTrigger, OverlayTrigger, Tooltip} = require 'react-bootstrap'
{option, select, button, i,a, strong, span, div, p, ul, li} = React.DOM
{Confirm} = require '../../../../../react/common/common'
date = require '../../../../../utils/date'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))
SapiTableLinkEx = require '../../components/StorageApiTableLinkEx'
utils = require '../../../utils'

module.exports = React.createClass
  displayName: 'tablerowtde'

  propTypes:
    table: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired
    tdeFile: React.PropTypes.object
    deleteRowFn: React.PropTypes.func
    prepareRunDataFn: React.PropTypes.func
    configData: React.PropTypes.object
    uploadComponentId: React.PropTypes.string
    uploadComponentIdSetFn: React.PropTypes.func

  render: ->
    div className: 'tr',
      span className: 'td',
        React.createElement SapiTableLinkEx,
          tableId: @props.table.get 'id'
        ,
          @props.table.get 'name'

      if @props.tdeFile
        span className: 'td',
          @_renderUploadIcon()
          React.createElement OverlayTrigger,
            overlay: React.createElement Tooltip,
              null
            ,
              div null, @props.tdeFile.getIn(['creatorToken','description'])
              div null, date.format @props.tdeFile.get('created')
              div null, filesize(@props.tdeFile.get('sizeBytes'))

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
            title: "Remove #{@props.table.get('id')}"
            text: 'You are about to remove table from the configuration.'
            buttonLabel: 'Remove'
            onConfirm: =>
              @props.deleteRowFn()
          ,
            button className: 'btn btn-link',
              i className: 'kbc-icon-cup'
        if not @props.isDeleted
          @_renderRunButton()

  _renderUploadIcon: ->
    fileName = @props.tdeFile.get('name')
    destinationOptions = @_generateDestinationOptions(@props.configData.get('parameters'))
    React.createElement OverlayTrigger,
      overlay: React.createElement Tooltip, null, 'Upload File'
      placement: 'top'
    ,
      RunButtonModal
        title: "Upload #{fileName}"
        disabled: _.isEmpty destinationOptions
        tooltip: "Upload #{fileName}"
        mode: 'button'
        icon: 'fa fa-upload fa-fw'
        component: @props.uploadComponentId
        runParams: =>
          console.log @props.uploadComponentId, @props.configData?.toJS()
          account = @props.configData.getIn ['parameters', 'tableauServer']
          if @props.uploadComponentId == 'wr-google-drive'
            account = @props.configData.getIn ['parameters', 'gdrive']
          if @props.uploadComponentId == 'wr-dropbox'
            account = @props.configData.getIn ['parameters', 'dropbox']
          result = utils.prepareUploadRunParams(@props.uploadComponentId, account, @props.tdeFile, @props.configId)
          console.log "reun dataaaa", result
          return result
      ,
        div null,
          "You are about to run upload of #{fileName} to:"
            select
              onChange: (e) =>
                value = e.target.value
                @props.uploadComponentIdSetFn(value)
              destinationOptions


  _generateDestinationOptions: (parameters) ->
    result = []
    if utils.isDropboxAuthorized(parameters.get('dropbox'))
      result.push(
        option
          value: 'wr-dropbox'
          key: 'wr-dropbox'
        ,
          'Dropbox'
      )
    if utils.isGdriveAuthorized(parameters.get('gdrive'))
      result.push(
        option
          value: 'wr-google-drive'
          key: 'wr-google-drive'
        ,
          'Google Drive'
      )
    if utils.isTableauServerAuthorized(parameters.get('tableauServer'))
      result.push(
        option
          value: 'wr-tableau-server'
          key: 'wr-tableau-server'
        ,
          'Tableau Server'
      )
    console.log "DESTINATION OPTIONS", result
    return result


  _renderRunButton: ->
    React.createElement OverlayTrigger,
      overlay: React.createElement Tooltip, null, 'Export to TDE File'
      placement: 'top'
    ,
      RunButtonModal
        title: "Export #{@props.table.get('id')} to TDE"
        tooltip: "Export #{@props.table.get('id')} to TDE"
        mode: 'button'
        component: 'tde-exporter'
        runParams: =>
          @props.prepareRunDataFn()
      ,
       "You are about to run export of #{@props.table.get('id')} to TDE."
