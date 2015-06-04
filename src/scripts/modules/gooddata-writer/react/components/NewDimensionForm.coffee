React = require 'react'

Input = React.createFactory(require('react-bootstrap').Input)
Button = React.createFactory(require('react-bootstrap').Button)
Loader = React.createFactory(require('kbc-react-components').Loader)

{form, span} = React.DOM

module.exports = React.createClass
  displayName: 'NewDateDimensionForm'

  propTypes:
    isPending: React.PropTypes.bool.isRequired
    onSubmit: React.PropTypes.func.isRequired
    onChange: React.PropTypes.func.isRequired
    dimension: React.PropTypes.object.isRequired

  getDefaultProps: ->
    className: 'form-inline'

  _handleInputChange: (field, e) ->
    @props.onChange @props.dimension.set(field, e.target.value)

  _handleCheckboxChange: (field, e) ->
    @props.onChange @props.dimension.set(field, e.target.checked)

  render: ->
    form className: @props.className,
      Input
        style: {'marginLeft': '5px', 'marginRight': '15px'}
        type: 'text'
        placeholder: 'Dimension name'
        label: 'Add Dimension: '
        value: @props.dimension.get 'name'
        disabled: @props.isPending
        onChange: @_handleInputChange.bind @, 'name'
      Input
        style: {'marginRight': '5px'}
        type: 'checkbox'
        label: 'Include time'
        disabled: @props.isPending
        checked: @props.dimension.get 'includeTime'
        onChange: @_handleCheckboxChange.bind @, 'includeTime'
      Button
        style: {'marginLeft': '15px'}
        bsStyle: 'success'
        disabled: @props.isPending || !@props.dimension.get('name').trim().length
        onClick: @props.onSubmit
      ,
        'Create'
      if @props.isPending
        span null,
          ' '
          Loader()
