React = require 'react'

{div} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
{Protected} = require 'kbc-react-components'

{form, div, h4, small, label, p, option} = React.DOM

module.exports = React.createClass

  displayName: 'WrDbCredentialsForm'
  propTypes:
    isEditing: React.PropTypes.bool
    credentials: React.PropTypes.object
    onChangeFn: React.PropTypes.func
    isSaving: React.PropTypes.bool

  render: ->

    form className: 'form-horizontal',
      h4 null
        if @props.isProvisioning
          h4 null,
            'Keboola provided database credentials'
            div null,
              small null, 'This is readonly credentials to the database provided by Keboola.'

        else
          h4 null,
            'User specified database credentials'

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
        disabled: @props.isSaving
        value: @props.credentials.get propName
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
        onChange: (event) =>
          @props.onChangeFn(propName, event)
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
