React = require 'react'
Clipboard = React.createFactory(require '../../../../../react/common/Clipboard')
fieldsTemplates = require '../../../templates/credentialsFields'

_ = require 'underscore'

{div} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
{Protected} = require 'kbc-react-components'

{form, div, h2, small, label, p, option} = React.DOM


module.exports = React.createClass

  displayName: 'WrDbCredentialsForm'
  propTypes:
    isEditing: React.PropTypes.bool
    credentials: React.PropTypes.object
    onChangeFn: React.PropTypes.func
    isSaving: React.PropTypes.bool
    isProvisioning: React.PropTypes.bool
    componentId: React.PropTypes.string

  render: ->
    fields = fieldsTemplates(@props.componentId)

    form className: 'form-horizontal',
      div className: 'row',
        if @props.isProvisioning
          h2 null,
            'Keboola provided database credentials'
            div null,
              small null, 'This is readonly credentials to the database provided by Keboola.'

        else
          h2 null,
            'User specified database credentials'

      div className: 'row',
        _.map fields, (field) =>
          @_createInput(field[0], field[1], field[2], field[3], field[4])

  _createInput: (labelValue, propName, type = 'text', isProtected = false) ->
    if @props.isEditing
      Input
        label: @_getName(propName) or labelValue
        type: type
        disabled: @props.isSaving
        value: @props.credentials.get propName
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
        onChange: (event) =>
          @props.onChangeFn(propName, event)
    else if isProtected
      StaticText
        label: @_getName(propName) or labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      ,
        React.createElement Protected, null,
          @props.credentials.get propName
        Clipboard text: @props.credentials.get propName
    else
      StaticText
        label: @_getName(propName) or labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      ,
        @props.credentials.get propName
        Clipboard text: @props.credentials.get propName

  _getName: (field) ->
    return null
    templates = fieldNames[@props.componentId]
    if templates
      return templates[field]
