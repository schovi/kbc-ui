React = require 'react'
_ = require 'underscore'
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))
ComponentsStore  = require('../../../../components/stores/ComponentsStore')

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
    if _.isEmpty destinationOptions.options
      @_renderDisabledRunButton()
    else
      React.createElement OverlayTrigger,
        overlay: React.createElement Tooltip, null, 'Upload File to a configured destination.'
        placement: 'top'
      ,
        RunButtonModal
          title: "Upload #{fileName}"
          tooltip: "Upload #{fileName}"
          mode: 'button'
          icon: 'fa fa-upload fa-fw'
          component: @props.uploadComponentId or destinationOptions.initValue
          runParams: =>
            @_generateRunParams(@props.uploadComponentId or destinationOptions.initValue)
        ,
          @_renderRunModalBody(destinationOptions, fileName)

  _renderDisabledRunButton: ->
    React.createElement OverlayTrigger,
      overlay: React.createElement Tooltip, null, 'Upload File. No upload destination configured'
      placement: 'top'
    ,
      button
        className: 'btn btn-link'
        disabled: true
      ,
        i className: 'fa fa-upload fa-fw'


  _renderRunModalBody: (destinationOptions, fileName) ->
    div className: 'modal-body',
      div className: 'form form-horizontal',
        p className: '', "You are about to run upload of #{fileName} to:"
        React.createElement Input,
          type: 'select'
          wrapperClassName: 'col-sm-10'
          value: @props.uploadComponentId or destinationOptions.initValue
          onChange: (e) =>
            value = e.target.value
            @props.uploadComponentIdSetFn(value)
          destinationOptions.options


  _generateRunParams: (uploadComponentId) ->
    result = uploadUtils.prepareUploadRunParams(
      uploadComponentId
      @props.configData.get('parameters')
      @props.tdeFile
      @props.configId
    )
    return result

  _generateOption: (id, caption) ->
    component = ComponentsStore.getComponent(id)
    #icon = ComponentIcon {component: component, size: '32'}
    option
      value: id
      key: id
    ,
      span {className: ''},
        span null,
          component.get('name')
          ' - '
          caption

  _generateDestinationOptions: (parameters) ->
    result = []
    console.log parameters?.toJS()
    initValue = ''
    if uploadUtils.isDropboxAuthorized(parameters)
      initValue = 'wr-dropbox'
      result.push(@_generateOption(
        'wr-dropbox'
        parameters.getIn ['dropbox','description']
      ))
    if uploadUtils.isGdriveAuthorized(parameters)
      initValue = 'wr-google-drive'
      result.push(@_generateOption(
        'wr-google-drive'
        parameters.getIn ['gdrive', 'email']
      ))

    if uploadUtils.isTableauServerAuthorized(parameters)
      initValue = 'wr-tableau-server'
      result.push(@_generateOption(
        'wr-tableau-server'
        "#{parameters.getIn(['tableauServer', 'server_url'])}"

      ))
    return { options: result, initValue: initValue}
