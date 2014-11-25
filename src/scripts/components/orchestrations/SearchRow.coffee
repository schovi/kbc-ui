React = require 'react'

{div, span, input} = React.DOM

SearchRow = React.createClass
  displayName: 'SearchRow'
  propTypes:
    query: React.PropTypes.string.isRequired
  componentDidMount: ->
    @refs.searchInput.getDOMNode().focus()
  render: ->
    div className: 'row kbc-search kbc-search-row',
      span className: 'kbc-icon-search'
      input type: 'text', className: 'form-control', placeholder: 'Search', ref: 'searchInput'

module.exports = SearchRow
