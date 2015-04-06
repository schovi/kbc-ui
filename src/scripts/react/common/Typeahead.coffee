React = require 'react'
Typeahead = require 'typeahead'

module.exports = React.createClass
  displayName: 'Typeahead'
  propTypes:
    value: React.PropTypes.string.isRequired
    options: React.PropTypes.array.isRequired
    onChange: React.PropTypes.func.isRequired
    placeholder: React.PropTypes.string

  componentDidMount: ->
    ta = Typeahead @refs.input.getDOMNode(),
        source: @props.options
        position: 'below'

  render: ->
    console.log 'render', @props
    React.DOM.input
      className: 'form-control'
      onChange: @props.onChange
      value: @props.value
      ref: 'input'
      placeholder: @props.placeholder
