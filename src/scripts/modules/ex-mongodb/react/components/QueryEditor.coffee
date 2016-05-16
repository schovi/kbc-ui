React = require 'react'
fuzzy = require 'fuzzy'
string = require '../../../../utils/string'
CodeEditor  = React.createFactory(require('../../../../react/common/common').CodeEditor)
Check = React.createFactory(require('../../../../react/common/common').Check)
Select = React.createFactory require('../../../../react/common/Select').default

Autosuggest = React.createFactory(require 'react-autosuggest')
editorMode = require('../../templates/editorMode').default

{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong, input, label, textarea} = React.DOM

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
    exports: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    outTableExist: React.PropTypes.bool
    configId: React.PropTypes.string.isRequired
    componentId: React.PropTypes.string.isRequired

  componentDidMount: ->
    React.findDOMNode(this.refs.newName).focus()

  _handleNameChange: (event) ->
    @props.onChange(@props.query.set 'newName', event.target.value)

  _handleIncrementalChange: (event) ->
    @props.onChange(@props.query.set 'incremental', event.target.checked)

  _handleQueryChange: (event) ->
    @props.onChange(@props.query.set 'query', event.target.value)

  _handleSortChange: (event) ->
    @props.onChange(@props.query.set 'sort', event.target.value)

  _handleLimitChange: (event) ->
    @props.onChange(@props.query.set 'limit', event.target.value)

  _handleMappingChange: (event) ->
    @props.onChange(@props.query.set 'mapping', event.target.value)

  _handleCollectionChange: (event) ->
    @props.onChange(@props.query.set 'collection', event.target.value)

  render: ->
    div className: 'row',
      div className: 'form-horizontal',

        div className: (if @props.outTableExist then 'form-group has-error' else 'form-group'),
          label className: 'col-md-2 control-label', 'Name'
          div className: 'col-md-4',
            input
              className: 'form-control'
              type: 'text'
              value: @props.query.get 'newName'
              ref: 'newName'
              placeholder: 'e.g. last-100-articles'
              onChange: @_handleNameChange
            if @props.outTableExist
              div className: 'help-block',
                "Table with such name already exists."

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Collection'
          div className: 'col-md-4',
            input
              className: 'form-control'
              type: 'text'
              value: @props.query.get 'collection'
              placeholder: 'e.g. Article'
              onChange: @_handleCollectionChange

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Query'
          div className: 'col-md-10',
            textarea
              className: 'form-control'
              placeholder: 'e.g. {isActive: 1, isDeleted: 0}'
              value: @props.query.get 'query'
              onChange: @_handleQueryChange
              style:
                width: '100%'

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Sort'
          div className: 'col-md-10',
            textarea
              className: 'form-control'
              placeholder: 'e.g. {creationDate: -1}'
              value: @props.query.get 'sort'
              onChange: @_handleSortChange
              style:
                width: '100%'

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Limit'
          div className: 'col-md-4',
            input
              className: 'form-control'
              placeholder: 'e.g. 100'
              type: 'text'
              value: @props.query.get 'limit'
              onChange: @_handleLimitChange

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Incremental'
          div className: 'col-md-4',
            div
              style:
                marginTop: '1em'
                paddingLeft: '1em',
            label null,
              input
                type: 'checkbox'
                checked: @props.query.get 'incremental'
                onChange: @_handleIncrementalChange

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Mapping'
          div className: 'col-md-10',
            textarea
              className: 'form-control'
              placeholder: 'e.g.\n"_id.$oid": {\n  "type": "column",\n  "mapping": ' +
                '{\n    "destination": "id",\n    "primaryKey": true\n  }\n}'
              value: @props.query.get 'mapping'
              onChange: @_handleMappingChange
              rows: 10
              style:
                width: '100%'
