React = require('react')

{div, form, input,span} = React.DOM

QueryRow = React.createClass
  displayName: 'QueryRow'
  propTypes:
    onSearch: React.PropTypes.func.isRequired

  getInitialState: ->
    query: @props.query


  _onQueryChange: (event) ->
    @setState
      query:event.target.value
  _doSearch: (event) ->
    @props.onSearch @state.query
    event.preventDefault()
  render: ->
    form {onSubmit: @_doSearch},
      div {className: 'row kbc-search kbc-search-row'},
        span {className: 'kbc-icon-search'}
        input {type:'text', value: @state.query, className: 'form-control', onChange: @_onQueryChange, placeholder: 'search'}



module.exports = QueryRow
