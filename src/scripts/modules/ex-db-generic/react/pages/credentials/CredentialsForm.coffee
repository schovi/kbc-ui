React = require 'react'
{Map} = require 'immutable'
_ = require 'underscore'
Clipboard = React.createFactory(require('../../../../../react/common/Clipboard').default)

Input = React.createFactory(require('react-bootstrap').Input)
TestCredentialsButtonGroup = React.createFactory(require './TestCredentialsButtonGroup')
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
Tooltip = require('../../../../../react/common/Tooltip').default
SshTunnelRow = React.createFactory(require('../../../../../react/common/SshTunnelRow').default)

{small, span, form, div, label, p, option} = React.DOM

module.exports = React.createClass
  displayName: 'ExDbCredentialsForm'
  propTypes:
    savedCredentials: React.PropTypes.object.isRequired
    credentials: React.PropTypes.object.isRequired
    enabled: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func
    componentId: React.PropTypes.string.isRequired
    configId: React.PropTypes.string.isRequired
    credentialsTemplate: React.PropTypes.object.isRequired
    hasSshTunnel: React.PropTypes.func.isRequired
    actionsProvisioning: React.PropTypes.object.isRequired

  getDefaultProps: ->
    onChange: ->

  render: ->
    form className: 'form-horizontal',
      div className: 'row',
        this.props.credentialsTemplate.getFields(@props.componentId).map((field) =>
          @_createInput(field[0], field[1], field[2], field[3])
          )
      if this.props.hasSshTunnel(this.props.componentId)
        SshTunnelRow
          isEditing: @props.enabled
          data: @props.credentials.get('ssh') or Map()
          onChange: (sshObject) =>
            @props.onChange(@props.credentials.set('ssh', sshObject))
      TestCredentialsButtonGroup
        credentials: @props.credentials
        componentId: @props.componentId
        configId: @props.configId
        actionsProvisioning: @props.actionsProvisioning

  _handleChange: (propName, event) ->
    if ['port'].indexOf(propName) >= 0
      value = parseInt event.target.value
    else
      value = event.target.value
    @props.onChange(@props.credentials.set propName, value)

  _createInput: (labelValue, propName, type = 'text', isProtected = false) ->
    if @props.enabled
      if isProtected
        @_createProtectedInput(labelValue, propName)
      else
        Input
          label: labelValue
          type: type
          value: @props.credentials.get propName
          labelClassName: 'col-xs-4'
          wrapperClassName: 'col-xs-8'
          onChange: @_handleChange.bind @, propName
    else if isProtected
      StaticText
        label: labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      ,
        React.createElement Tooltip,
          tooltip: 'Encrypted password',
          span className: 'fa fa-fw fa-lock', null
    else
      StaticText
        label: labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      ,
        @props.credentials.get propName
        if @props.credentials.get propName
          Clipboard
            text: @props.credentials.get propName

  _createProtectedInput: (labelValue, propName) ->
    savedValue = this.props.savedCredentials.get(propName)

    Input
      label: @_renderProtectedLabel(labelValue, !!savedValue)
      type: 'password'
      placeholder: if savedValue then 'type new password to change it' else ''
      value: @props.credentials.get propName
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      onChange: @_handleChange.bind @, propName

  _renderProtectedLabel: (labelValue, alreadyEncrypted) ->
    msg = "#{labelValue} will be stored securely encrypted."
    if alreadyEncrypted
      msg = msg + ' The most recently stored value will be used if left empty.'
    span null,
      labelValue
      small null,
        React.createElement Tooltip,
          placement: 'top'
          tooltip: msg,
          span className: 'fa fa-fw fa-question-circle', null


  _createSelect: (labelValue, propName, options) ->
    if @props.enabled
      Input
        label: labelValue
        type: 'select'
        value: @props.credentials.get propName
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
        onChange: @_handleChange.bind @, propName
      ,
        allOptions = _.map(options, (label, value) ->
          option value: value,
            label
        )
        allOptions.unshift(option({value: "", disabled: "true"}, "Select"))
    else
      StaticText
        label: labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      ,
        @props.credentials.get(propName)
