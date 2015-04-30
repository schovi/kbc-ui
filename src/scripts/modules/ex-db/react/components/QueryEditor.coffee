React = require 'react'

CodeEditor  = React.createFactory(require('../../../../react/common/common').CodeEditor)
Check = React.createFactory(require('../../../../react/common/common').Check)
Typeahead = require '../../../../react/common/Typeahead'


{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong, input} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbQueryEditor'
  propTypes:
    query: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    showOutputTable: React.PropTypes.bool

  getDefaultProps: ->
    showOutputTable: false

  _handleOutputTableChange: (event) ->
    console.log 'change', newValue
    @props.onChange(@props.query.set 'outputTable', event.target.value)

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
                  React.createElement Typeahead,
                    value: @props.query.get 'outputTable'
                    onChange: @_handleOutputTableChange
                    options: @_tableSelectOptions().toArray()
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

  _filterOptions: (options, filter, currentValue) ->
    options = @_tableSelectOptions()
    .filter (option) ->
      fuzzy.match filter, option.label
    .sortBy (option) -> option.label
    .toArray()

    options.unshift
      label: filter
      value: filter

    options

  _tableSelectOptions: ->
    @props.tables
    .map (table) ->
      table.get 'id'
    .sortBy (val) -> val
