React = require 'react'
{Map} = require 'immutable'
_ = require 'underscore'

Input = React.createFactory(require('react-bootstrap').Input)
TestCredentialsButtonGroup = React.createFactory(require './TestCredentialsButtonGroup')
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
{Protected} = require 'kbc-react-components'
SshTunnelRow = React.createFactory(require('./SshTunnelRow').default)

CredentialsTemplate = require '../../../templates/credentials'

{form, div, label, p, option} = React.DOM

module.exports = React.createClass
  displayName: 'ExDbCredentialsForm'
  propTypes:
    credentials: React.PropTypes.object.isRequired
    enabled: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func
    componentId: React.PropTypes.string.isRequired

  getDefaultProps: ->
    onChange: ->

  render: ->
    form className: 'form-horizontal',
      div className: 'row',
        CredentialsTemplate.getFields(@props.componentId).map((field) =>
          @_createInput(field[0], field[1], field[2], field[3])
          )
      SshTunnelRow
        isEditing: @props.enabled
        data: @props.credentials.get('ssh') or Map()
        onChange: (sshObject) =>
          @props.onChange(@props.credentials.set('ssh', sshObject))

        TestCredentialsButtonGroup
          credentials: @props.credentials
          componentId: @props.componentId

  _handleChange: (propName, event) ->
    if ['port'].indexOf(propName) >= 0
      value = parseInt event.target.value
    else
      value = event.target.value
    @props.onChange(@props.credentials.set propName, value)

  _createInput: (labelValue, propName, type = 'text', isProtected = false) ->
    if @props.enabled
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
        React.createElement Protected, null,
          @props.credentials.get propName
    else
      StaticText
        label: labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      , @props.credentials.get propName

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
