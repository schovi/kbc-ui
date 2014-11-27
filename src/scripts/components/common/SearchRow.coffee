React = require 'react'

{div, span, input} = React.DOM

SearchRow = React.createClass
  displayName: 'SearchRow'
  propTypes:
    query: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired
    className: React.PropTypes.string

  getInitialState: ->
    query: @props.query

  componentDidMount: ->
    @refs.searchInput.getDOMNode().focus()

  _onChange: (event) ->
    @setState
      query: event.target.value
    @props.onChange event.target.value

  render: ->
    div className: 'kbc-search' + ' ' + @props.className,
      span className: 'kbc-icon-search'
      input
        type: 'text'
        value: @state.query
        className: 'form-control'
        placeholder: 'Search'
        ref: 'searchInput'
        onChange: @_onChange

module.exports = SearchRow
