React = require 'react'

FormHeader = React.createFactory(require './FormHeader')
Input = React.createFactory(require('react-bootstrap').Input)

{div, form, h3, p} = React.DOM

MODE_NEW = 'new'
MODE_EXISTING = 'existing'

TOKEN_TYPE_PRODUCTION = 'production'
TOKEN_TYPE_DEVELOPMENT = 'development'
TOKEN_TYPE_CUSTOM = 'custom'

module.exports = React.createClass
  displayName: 'GoodDataWriterDefaultForm'
  propTypes:
    component: React.PropTypes.object.isRequired
    configuration: React.PropTypes.object.isRequired
    onCancel: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired
    onChange: React.PropTypes.func.isRequired
    isValid: React.PropTypes.bool.isRequired
    isSaving: React.PropTypes.bool.isRequired

  _handleChange: (propName, event) ->
    @props.onChange @props.configuration.set(propName, event.target.value)

  render: ->
    form className: 'form-horizontal',
      FormHeader
        component: @props.component
        onCancel: @props.onCancel
        onSave: @props.onSave
        isValid: @props.isValid
        isSaving: @props.isSaving
      div className: 'row',
        div className: 'col-md-8',
          Input
            type: 'text'
            label: 'Name'
            value: @props.configuration.get 'name'
            placeholder: "My #{@props.component.get('name')}"
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-8'
            onChange: @_handleChange.bind @, 'name'
            disabled: @props.isSaving
          Input
            type: 'textarea'
            label: 'Description'
            value: @props.configuration.get 'description'
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-8'
            onChange: @_handleChange.bind @, 'description'
            disabled: @props.isSaving
      div className: 'row',
        div className: 'col-md-8',
          Input
            type: 'radio'
            label: 'Create new GoodData project'
            name: 'mode'
            value: MODE_NEW
            checked: @props.configuration.get('mode') == MODE_NEW
            onChange: @_handleChange.bind @, 'mode'
            wrapperClassName: 'col-xs-offset-2 col-xs-10'
          Input
            type: 'radio'
            name: 'mode'
            value: MODE_EXISTING
            label: 'Use existing GoodData project'
            checked: @props.configuration.get('mode') != MODE_NEW
            onChange: @_handleChange.bind @, 'mode'
            wrapperClassName: 'col-xs-offset-2 col-xs-10'
      if @props.configuration.get('mode') == MODE_NEW
        @_renderNewForm()
      else
        @_renderExistingForm()

  _renderNewForm: ->
    div className: 'row',
      div className: 'col-md-8',
        div className: 'col-xs-offset-2 col-xs-10',
          h3 null, 'GoodData access token'
        Input
          type: 'radio'
          label: 'Production'
          help: 'You are paying for it'
          name: 'tokenType'
          value: TOKEN_TYPE_PRODUCTION
          checked: @props.configuration.get('tokenType') == TOKEN_TYPE_PRODUCTION
          onChange: @_handleChange.bind @, 'tokenType'
          wrapperClassName: 'col-xs-offset-2 col-xs-10'
        Input
          type: 'radio'
          label: 'Development'
          help: 'max 2GB of data, expires in 2 months'
          name: 'tokenType'
          value: TOKEN_TYPE_DEVELOPMENT
          checked: @props.configuration.get('tokenType') == TOKEN_TYPE_DEVELOPMENT
          onChange: @_handleChange.bind @, 'tokenType'
          wrapperClassName: 'col-xs-offset-2 col-xs-10'
        Input
          type: 'radio'
          label: 'Custom'
          help: 'You have your own token'
          name: 'tokenType'
          value: TOKEN_TYPE_CUSTOM
          checked: @props.configuration.get('tokenType') == TOKEN_TYPE_CUSTOM
          onChange: @_handleChange.bind @, 'tokenType'
          wrapperClassName: 'col-xs-offset-2 col-xs-10'

  _renderExistingForm: ->
    div className: 'row',
      div className: 'col-md-8',
        div className: 'col-xs-offset-2 col-xs-10',
          h3 null, 'GoodData Project Admin Credentials'
          p className: 'help-text',
            'We will use these credentials just once to invite Keboola Domain Admin to your project.
            These credentials will not be stored anywhere or used for any other purpose,
            we will perform all other activity using the invited account.'

      div className: 'col-md-8',
        Input
          type: 'text'
          label: 'GoodData username'
          value: @props.configuration.get 'username'
          labelClassName: 'col-xs-2'
          wrapperClassName: 'col-xs-8'
          onChange: @_handleChange.bind @, 'username'
          disabled: @props.isSaving
        Input
          type: 'password'
          label: 'GoodData password'
          value: @props.configuration.get 'password'
          labelClassName: 'col-xs-2'
          wrapperClassName: 'col-xs-8'
          onChange: @_handleChange.bind @, 'password'
          disabled: @props.isSaving
        Input
          type: 'text'
          label: 'GoodData project ID'
          value: @props.configuration.get 'pid'
          labelClassName: 'col-xs-2'
          wrapperClassName: 'col-xs-8'
          onChange: @_handleChange.bind @, 'pid'
          disabled: @props.isSaving

