React = require 'react'
_ = require 'underscore'

ExDbActionCreators = require '../../../exDbActionCreators'

Input = React.createFactory(require('react-bootstrap').Input)
TestCredentialsButtonGroup = React.createFactory(require './TestCredentialsButtonGroup')
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
{Protected} = require 'kbc-react-components'

{form, div, label, p, option} = React.DOM

_drivers =
  mysql: 'MySQL'
  mssql: 'MSSQL'
  pgsql: 'Postgre SQL'
  oracle: 'Oracle'

module.exports = React.createClass
  displayName: 'ExDbCredentialsForm'
  propTypes:
    credentials: React.PropTypes.object.isRequired
    enabled: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func

  getDefaultProps: ->
    onChange: ->

  render: ->
    form className: 'form-horizontal',
      div className: 'row',
        @_createSelect 'Driver', 'driver', _drivers
        @_createInput 'Host name', 'host'
        @_createInput 'Port', 'port', 'number'
        @_createInput 'Username', 'user'
        @_createInput 'Password', 'password', 'password', true
        @_createInput 'Database', 'database', 'text'
        @_createInput 'Connection retries', 'retries', 'number'
        TestCredentialsButtonGroup
          credentials: @props.credentials

  _handleChange: (propName, event) ->
    if ['port', 'retries'].indexOf(propName) >= 0
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
        allOptions.unshift(option({value: "", disabled: "true"}, "Select driver"))
    else
      StaticText
        label: labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      , @props.credentials.get propName
