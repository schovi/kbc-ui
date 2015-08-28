React = require 'react'
_ = require 'underscore'

RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))
{Input, ModalTrigger, OverlayTrigger, Tooltip} = require 'react-bootstrap'
{option, select, button, i,a, strong, span, div, p, ul, li} = React.DOM

uploadUtils = require '../../../uploadUtils'

module.exports = React.createClass
  displayName: 'TdeUploadButton'

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
        runParams: @_generateRunParams
        div null,
          "You are about to run upload of #{fileName} to:"
            select
              onChange: (e) =>
                value = e.target.value
                @props.uploadComponentIdSetFn(value)
              destinationOptions


  _generateRunParams: ->
    console.log @props.uploadComponentId, @props.configData?.toJS()
    account = @props.configData.getIn ['parameters', 'tableauServer']
    if @props.uploadComponentId == 'wr-google-drive'
      account = @props.configData.getIn ['parameters', 'gdrive']
    if @props.uploadComponentId == 'wr-dropbox'
      account = @props.configData.getIn ['parameters', 'dropbox']
      
    result = uploadUtils.prepareUploadRunParams(
      @props.uploadComponentId
      account
      @props.tdeFile
      @props.configId
    )

    console.log "reun dataaaa", result
    return result


  _generateDestinationOptions: (parameters) ->
    result = []
    if uploadUtils.isDropboxAuthorized(parameters.get('dropbox'))
      result.push(
        option
          value: 'wr-dropbox'
          key: 'wr-dropbox'
        ,
          'Dropbox'
      )
    if uploadUtils.isGdriveAuthorized(parameters.get('gdrive'))
      result.push(
        option
          value: 'wr-google-drive'
          key: 'wr-google-drive'
        ,
          'Google Drive'
      )
    if uploadUtils.isTableauServerAuthorized(parameters.get('tableauServer'))
      result.push(
        option
          value: 'wr-tableau-server'
          key: 'wr-tableau-server'
        ,
          'Tableau Server'
      )
    console.log "DESTINATION OPTIONS", result
    return result
