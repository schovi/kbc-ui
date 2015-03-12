React = require 'react'
Typeahead = require 'typeahead'

module.exports = React.createClass
  propTypes:
    value: React.PropTypes.string.isRequired
    options: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired

  componentDidMount: ->
    ta = Typeahead @refs.input.getDOMNode(),
        source: @props.options

  render: ->
    console.log 'render', @props
    React.DOM.input
      className: 'form-control'
      onChange: @props.onChange
      value: @props.value
      ref: 'input'
