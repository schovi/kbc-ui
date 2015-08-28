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
        disabled: _.isEmpty destinationOptions.options
        tooltip: "Upload #{fileName}"
        mode: 'button'
        icon: 'fa fa-upload fa-fw'
        component: @props.uploadComponentId
        runParams: @_generateRunParams
      ,
        @_renderRunModalBody(destinationOptions, fileName)

  _renderRunModalBody: (destinationOptions, fileName) ->
    div null,
      "You are about to run upload of #{fileName} to:"
        select
          value: @props.uploadComponentId or destinationOptions.initValue
          onChange: (e) =>
            value = e.target.value
            @props.uploadComponentIdSetFn(value)
          destinationOptions.options


  _generateRunParams: ->
    console.log @props.uploadComponentId, @props.configData?.toJS()

    result = uploadUtils.prepareUploadRunParams(
      @props.uploadComponentId
      @props.configData.get('parameters')
      @props.tdeFile
      @props.configId
    )

    console.log "reun dataaaa", result
    return result

  _generateOption: (id, caption) ->
    option
      value: id
      key: id
    ,
      caption


  _generateDestinationOptions: (parameters) ->
    result = []
    initValue = ''
    if uploadUtils.isDropboxAuthorized(parameters)
      initValue = 'wr-dropbox'
      result.push(@_generateOption(
        'wr-dropbox'
        'Dropbox'
      ))
    if uploadUtils.isGdriveAuthorized(parameters)
      initValue = 'wr-google-drive'
      result.push(@_generateOption(
        'wr-google-drive'
        'Google Drive'
      ))

    if uploadUtils.isTableauServerAuthorized(parameters)
      initValue = 'wr-tableau-server'
      result.push(@_generateOption(
        'wr-tableau-server'
        'Tableau Server'
      ))
    return { options: result, initValue: initValue}
