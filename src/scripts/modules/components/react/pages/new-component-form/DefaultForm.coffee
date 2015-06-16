React = require 'react'

FormHeader = React.createFactory(require './FormHeader')
Input = React.createFactory(require('react-bootstrap').Input)
AppVendorInfo = React.createFactory(require './appVendorinfo')
{div, form} = React.DOM



module.exports = React.createClass
  displayName: 'NewComponentDefaultForm'
  propTypes:
    component: React.PropTypes.object.isRequired
    configuration: React.PropTypes.object.isRequired
    onCancel: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired
    onChange: React.PropTypes.func.isRequired
    isValid: React.PropTypes.bool.isRequired
    isSaving: React.PropTypes.bool.isRequired

  componentDidMount: ->
    @refs.name.getInputDOMNode().focus()

  _handleChange: (propName, event) ->
    @props.onChange(@props.configuration.set propName, event.target.value)

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
            ref: 'name'
            value: @props.configuration.get 'name'
            placeholder: "My #{@props.component.get('name')}"
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-10'
            onChange: @_handleChange.bind @, 'name'
            disabled: @props.isSaving
          Input
            type: 'textarea'
            label: 'Description'
            value: @props.configuration.get 'description'
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-10'
            onChange: @_handleChange.bind @, 'description'
            disabled: @props.isSaving
          @_renderAppVendorInfo() if (@props.component.get('is3rdParty') == true or true)

  _renderAppVendorInfo: ->
    componentData = @props.component.get('data')
    AppVendorInfo
      data: componentData
