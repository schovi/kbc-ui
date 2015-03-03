React = require 'react'

Input = React.createFactory(require('react-bootstrap').Input)
Button = React.createFactory(require('react-bootstrap').Button)
Loader = React.createFactory(require('../../../../react/common/Loader'))

{form, span} = React.DOM

module.exports = React.createClass
  displayName: 'NewDateDimensionForm'

  propTypes:
    isPending: React.PropTypes.bool.isRequired
    onSubmit: React.PropTypes.func.isRequired
    onChange: React.PropTypes.func.isRequired
    dimension: React.PropTypes.object.isRequired


  _handleInputChange: (field, e) ->
    @props.onChange @props.dimension.set(field, e.target.value)

  _handleCheckboxChange: (field, e) ->
    @props.onChange @props.dimension.set(field, e.target.checked)

  render: ->
    form className: 'form-horizontal',
      Input
        type: 'text'
        placeholder: 'Dimension name'
        label: 'name'
        value: @props.dimension.get 'name'
        disabled: @props.isPending
        onChange: @_handleInputChange.bind @, 'name'
      Input
        type: 'checkbox'
        label: 'Include time'
        disabled: @props.isPending
        checked: @props.dimension.get 'includeTime'
        onChange: @_handleCheckboxChange.bind @, 'includeTime'
      Button
        bsStyle: 'success'
        disabled: @props.isPending || !@props.dimension.get('name').trim().length
        onClick: @props.onSubmit
      ,
        'Create'
      if @props.isPending
        span null,
          ' '
          Loader()
