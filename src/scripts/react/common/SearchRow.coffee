React = require 'react'

{form, span, input} = React.DOM

SearchRow = React.createClass
  displayName: 'SearchRow'
  propTypes:
    query: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func
    onSubmit: React.PropTypes.func
    className: React.PropTypes.string

  getInitialState: ->
    query: @props.query

  getDefaultProps: ->
    onChange: ->
    onSubmit: (e) ->
      event.preventDefault()

  componentDidMount: ->
    @refs.searchInput.getDOMNode().focus()

  _onChange: (event) ->
    @setState
      query: event.target.value
    @props.onChange event.target.value

  _onSubmit: (event) ->
    event.preventDefault()
    @props.onSubmit(@state.query)

  render: ->
    form
      className: 'kbc-search' + ' ' + @props.className
      onSubmit: @_onSubmit
    ,
      span className: 'kbc-icon-search'
      input
        type: 'text'
        value: @state.query
        className: 'form-control'
        placeholder: 'Search'
        ref: 'searchInput'
        onChange: @_onChange

module.exports = SearchRow
