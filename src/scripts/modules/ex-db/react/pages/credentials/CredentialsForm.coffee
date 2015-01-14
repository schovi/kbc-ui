React = require 'react'
Input = React.createFactory(require('react-bootstrap').Input)

{form, div} = React.DOM

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
        @_createInput 'Host name', 'host'
        @_createInput 'Port', 'port'
        @_createInput 'Username', 'user'
        @_createInput 'Password', 'password'
        @_createInput 'Connection retries', 'retries'

  _handleChange: (propName, event) ->
    @props.onChange(@props.credentials.set propName, event.target.value)

  _createInput: (label, propName) ->
    Input
      label: label
      type: 'text'
      disabled: !@props.enabled
      value: @props.credentials.get propName
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      onChange: @_handleChange.bind @, propName