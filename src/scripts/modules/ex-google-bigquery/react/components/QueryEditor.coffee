React = require 'react'
fuzzy = require 'fuzzy'
string = require('../../../../utils/string').default
CodeEditor  = React.createFactory(require('../../../../react/common/common').CodeEditor)
Select = React.createFactory require('../../../../react/common/Select').default

Autosuggest = React.createFactory(require 'react-autosuggest')
editorMode = require('../../../ex-db-generic/templates/editorMode').default

{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong, input, label, i} = React.DOM

createGetSuggestions = (getOptions) ->
  (input, callback) ->
    suggestions = getOptions()
      .filter (value) -> fuzzy.match(input, value)
      .slice 0, 10
      .toList()
    callback(null, suggestions.toJS())


module.exports = React.createClass
  displayName: 'ExDbQueryEditor'
  propTypes:
    query: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    showOutputTable: React.PropTypes.bool
    configId: React.PropTypes.string.isRequired
    defaultOutputTable: React.PropTypes.string.isRequired
    componentId: React.PropTypes.string.isRequired

  componentDidMount: ->
    React.findDOMNode(this.refs.queryName).focus()

  _handleOutputTableChange: (newValue) ->
    @props.onChange(@props.query.set 'outputTable', newValue)

  _handlePrimaryKeyChange: (newValue) ->
    @props.onChange(@props.query.set 'primaryKey', newValue)

  _handleIncrementalChange: (event) ->
    @props.onChange(@props.query.set 'incremental', event.target.checked)

  _handleLegacySqlChange: (event) ->
    @props.onChange(@props.query.set 'useLegacySql', event.target.checked)

  _handleQueryChange: (data) ->
    @props.onChange(@props.query.set 'query', data.value)

  _handleNameChange: (event) ->
    @props.onChange(@props.query.set 'name', event.target.value)

  _tableNamePlaceholder: ->
    return 'default: ' + @props.defaultOutputTable

  render: ->
    div className: 'row',
      div className: 'form-horizontal',
        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Name'
          div className: 'col-md-4',
            input
              className: 'form-control'
              type: 'text'
              value: @props.query.get 'name'
              ref: 'queryName'
              placeholder: 'e.g. Untitled Query'
              onChange: @_handleNameChange
          label className: 'col-md-2 control-label', 'Primary key'
          div className: 'col-md-4',
          Select
            name: 'primaryKey'
            value: @props.query.get 'primaryKey'
            multi: true
            disabled: false
            allowCreate: true
            delimiter: ','
            placeholder: 'No primary key'
            emptyStrings: false
            onChange: @_handlePrimaryKeyChange
        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Output table'
          div className: 'col-md-6',
            Autosuggest
              suggestions: createGetSuggestions(@_tableSelectOptions)
              inputAttributes:
                className: 'form-control'
                placeholder: @_tableNamePlaceholder()
                value: @props.query.get 'outputTable'
                onChange: @_handleOutputTableChange
            div className: 'help-block',
              "if empty then default will be used"
          div className: 'col-md-4 checkbox',
            label null,
              input
                type: 'checkbox'
                checked: @props.query.get 'incremental'
                onChange: @_handleIncrementalChange
              'Incremental'
        div className: 'form-group',
          label className: 'col-md-2 control-label', ''
          div className: 'col-md-10 checkbox',
            label null,
              input
                type: 'checkbox'
                checked: @props.query.get 'useLegacySql'
                onChange: @_handleLegacySqlChange
              'Use Legacy SQL'
            div className: 'help-block',
              "specifies whether to use BigQuery\'s legacy SQL dialect or BigQuery\'s standard SQL"
        div className: 'form-group',
          label className: 'col-md-12 control-label', 'SQL query'
          if @props.componentId is 'keboola.ex-db-oracle'
            div className: 'col-md-12',
              div className: 'help-block',
                "Do not leave semicolon at the end of the query."
          div className: 'col-md-12',
            CodeEditor
              readOnly: false
              placeholder: 'e.g. SELECT `id`, `name` FROM `myTable`'
              value: @props.query.get 'query'
              mode: editorMode(@props.componentId)
              onChange: @_handleQueryChange
              style: {
                width: '100%'
              }

  _tableSelectOptions: ->
    @props.tables
    .map (table) ->
      table.get 'id'
    .sortBy (val) -> val
