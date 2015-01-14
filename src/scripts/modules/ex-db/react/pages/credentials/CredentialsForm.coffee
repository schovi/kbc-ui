React = require 'react'
_ = require 'underscore'

ExDbActionCreators = require '../../../exDbActionCreators.coffee'

Input = React.createFactory(require('react-bootstrap').Input)
TestCredentialsButtonGroup = React.createFactory(require './TestCredentialsButtonGroup.coffee')

{form, div, label, p, option} = React.DOM

_drivers =
  mysql: 'MySQL'
  mssql: 'MSSQL'
  pgsql: 'Postgre SQL'

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
        @_createInput 'Port', 'port'
        @_createInput 'Username', 'user'
        @_createInput 'Password', 'password'
        @_createInput 'Connection retries', 'retries'
        TestCredentialsButtonGroup
          credentials: @props.credentials

  _handleChange: (propName, event) ->
    @props.onChange(@props.credentials.set propName, event.target.value)

  _createInput: (labelValue, propName) ->
    if @props.enabled
      Input
        label: labelValue
        type: 'text'
        value: @props.credentials.get propName
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
        onChange: @_handleChange.bind @, propName
    else
      @_createStaticControl labelValue, propName

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
        _.map options, (label, value) ->
          option value: value,
            label
    else
      @_createStaticControl labelValue, propName

  _createStaticControl: (labelValue, propName) ->
    div className: 'form-group',
      label className: 'control-label col-xs-4',
        labelValue
      div className: 'col-xs-8',
        p className: 'form-control-static',
          @props.credentials.get propName

