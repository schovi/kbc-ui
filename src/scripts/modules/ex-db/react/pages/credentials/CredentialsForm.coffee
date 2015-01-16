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
    console.log 'credentials', @props.credentials.toJS()
    form className: 'form-horizontal',
      div className: 'row',
        @_createSelect 'Driver', 'driver', _drivers
        @_createInput 'Host name', 'host'
        @_createInput 'Port', 'port', 'number'
        @_createInput 'Username', 'user'
        @_createInput 'Password', 'password'
        @_createInput 'Connection retries', 'retries', 'number'
        TestCredentialsButtonGroup
          credentials: @props.credentials

  _handleChange: (propName, event) ->
    if ['port', 'retries'].indexOf propName >= 0
      value = parseInt event.target.value
    else
      value = event.target.value
    @props.onChange(@props.credentials.set propName, value)

  _createInput: (labelValue, propName, type = 'text') ->
    Input
      label: labelValue
      type: if @props.enabled then type else 'static'
      value: @props.credentials.get propName
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      onChange: @_handleChange.bind @, propName

  _createSelect: (labelValue, propName, options) ->
    Input
      label: labelValue
      type: if @props.enabled then 'select' else 'static'
      value: @props.credentials.get propName
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      onChange: @_handleChange.bind @, propName
    ,
      _.map options, (label, value) ->
        option value: value,
          label
