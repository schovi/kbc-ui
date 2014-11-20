React = require 'react'

{div, span, input} = React.DOM

SearchRow = React.createClass
  displayName: 'SearchRow'
  propTypes:
    query: React.PropTypes.string.isRequired
  render: ->
    div className: 'row kbc-search-row',
      span className: 'kbc-icon-search'
      input type: 'text', className: 'form-control'

module.exports = SearchRow
