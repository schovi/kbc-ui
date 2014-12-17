React = require('react')

{div, form, input,span} = React.DOM

QueryRow = React.createClass
  displayName:"QueryRow"
  propTypes:
    onSearch: React.PropTypes.func.isRequired

  getInitialState: ->
    query:@props.query


  _onQueryChange: (event) ->
    @setState
      query:event.target.value
  _doSearch: (event) ->
    @props.onSearch @state.query
    event.preventDefault()
  render: ->
    div {className:"form-group form-group-sm"},
      form {onSubmit:@_doSearch},
        div {className:"input-group"},
          input {type:'text', value:@state.query, className:'form-control', onChange: @_onQueryChange, placeholder:"search"},
          div {className:"input-group-addon"},
            span {className:"fa fa-fw fa-search", onClick:@_doSearch}



module.exports = QueryRow
