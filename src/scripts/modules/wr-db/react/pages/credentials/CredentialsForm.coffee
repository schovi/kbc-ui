React = require 'react'

{div} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
{Protected} = require 'kbc-react-components'

{form, div, label, p, option} = React.DOM

module.exports = React.createClass

  displayName: 'WrDbCredentialsForm'
  propTypes:
    isEditing: React.PropTypes.bool
    credentials: React.PropTypes.object
    onChangeFn: React.PropTypes.func

  render: ->
    form className: 'form-horizontal',
      div className: 'row',
        @_createInput 'Host name', 'host'
        @_createInput 'Port', 'port', 'number'
        @_createInput 'Username', 'user'
        @_createInput 'Password', 'password', 'password', true
        @_createInput 'Database Name', 'database', 'text'


  _createInput: (labelValue, propName, type = 'text', isProtected = false) ->
    if @props.isEditing
      Input
        label: labelValue
        type: type
        value: @props.credentials.get propName
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
        onChange: @props.onChangeFn.bind propName
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
