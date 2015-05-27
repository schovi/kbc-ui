React = require 'react'
fuzzy = require 'fuzzy'

CodeEditor  = React.createFactory(require('../../../../react/common/common').CodeEditor)
Check = React.createFactory(require('../../../../react/common/common').Check)

Autosuggest = React.createFactory(require 'react-autosuggest')

{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong, input} = React.DOM

createGetSuggestions = (getOptions) ->
  (input, callback) ->
    suggestions = getOptions()
      .filter (value) -> fuzzy.match(input, value)
      .slice 0, 10
      .toList()

    console.log 'suggestions', suggestions.toJS()
    callback(null, suggestions.toJS())


module.exports = React.createClass
  displayName: 'ExDbQueryEditor'
  propTypes:
    query: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    showOutputTable: React.PropTypes.bool

  getDefaultProps: ->
    showOutputTable: false

  _handleOutputTableChange: (newValue) ->
    @props.onChange(@props.query.set 'outputTable', newValue)

  _handlePrimaryKeyChange: (event) ->
    @props.onChange(@props.query.set 'primaryKey', event.target.value)

  _handleIncrementalChange: (event) ->
    @props.onChange(@props.query.set 'incremental', event.target.checked)

  _handleQueryChange: (data) ->
    @props.onChange(@props.query.set 'query', data.value)

  _handleNameChange: (event) ->
    @props.onChange(@props.query.set 'name', event.target.value)

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'table kbc-table-border-vertical kbc-detail-table',
        div className: 'tr',
          div className: 'td',
            div className: 'row',
              span className: 'col-md-3', 'Name '
              strong className: 'col-md-9',
                input
                  className: 'form-control'
                  type: 'text'
                  value: @props.query.get 'name'
                  placeholder: 'Untitled Query'
                  onChange: @_handleNameChange
            if @props.showOutputTable
              div className: 'row',
                span className: 'col-md-3', 'Output table '
                strong className: 'col-md-9',
                  Autosuggest
                    suggestions: createGetSuggestions(@_tableSelectOptions)
                    inputAttributes:
                      className: 'form-control'
                      placeholder: 'Output table ...'
                      value: @props.query.get 'outputTable'
                      onChange: @_handleOutputTableChange
          div className: 'td',
            div className: 'row',
              span className: 'col-md-3', 'Primary key '
              strong className: 'col-md-9',
                input
                  className: 'form-control'
                  type: 'text'
                  value: @props.query.get 'primaryKey'
                  placeholder: 'No primary key'
                  onChange: @_handlePrimaryKeyChange
            div className: 'row',
              span className: 'col-md-3', 'Incremental '
              strong className: 'col-md-9',
                input
                  type: 'checkbox'
                  checked: @props.query.get 'incremental'
                  onChange: @_handleIncrementalChange
      div
        style:
          'margin-top': '-30px'
      ,
        CodeEditor
          readOnly: false
          value: @props.query.get 'query'
          onChange: @_handleQueryChange


  _tableSelectOptions: ->
    console.log 'select opts'
    @props.tables
    .map (table) ->
      table.get 'id'
    .sortBy (val) -> val
