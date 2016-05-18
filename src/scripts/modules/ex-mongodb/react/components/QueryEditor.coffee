React = require 'react'
fuzzy = require 'fuzzy'
string = require '../../../../utils/string'
Check = React.createFactory(require('../../../../react/common/common').Check)
Select = React.createFactory require('../../../../react/common/Select').default

ExportHelp = React.createFactory require('./ExportHelp').default
LinkToDocs = React.createFactory require('./LinkToDocs').default

CodeMirror = React.createFactory(require 'react-code-mirror')

{div, small, table, tbody, tr, td, ul, li, a, span, h2, p, strong, input, label, textarea} = React.DOM

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
    @props.onChange(@props.query.set 'newMapping', event.target.value)

  _handleCollectionChange: (event) ->
    @props.onChange(@props.query.set 'collection', event.target.value)

  render: ->
    div className: 'row',
      LinkToDocs null

      div className: 'form-horizontal',

        div className: (if @props.outTableExist then 'form-group has-error' else 'form-group'),
          label className: 'col-md-2 control-label',
            'Name'
            ExportHelp
              message: 'Name has to be unique across all exports in current configuration'
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
          label className: 'col-md-2 control-label',
            'Query'
            ExportHelp
              message: 'Query to filter documents. Has to be valid JSON.'
          div className: 'col-md-10',
            CodeMirror
              placeholder: 'optional, e.g. {isActive: 1, isDeleted: 0}'
              value:
                if @props.query.get('query')
                  @props.query.get('query').toString()
              onChange: @_handleQueryChange
              mode: 'application/json'
              lint: true
              lineWrapping: true
              lineNumbers: true
              theme: 'solarized'

        div className: 'form-group',
          label className: 'col-md-2 control-label',
            'Sort'
            ExportHelp
              message: 'Sort results by specified keys. Has to be valid JSON.'
          div className: 'col-md-10',
            CodeMirror
              placeholder: 'optional, e.g. {creationDate: -1}'
              value:
                if @props.query.get('sort')
                  @props.query.get('sort').toString()
              onChange: @_handleSortChange
              mode: 'application/json'
              lint: true
              lineWrapping: true
              lineNumbers: true
              theme: 'solarized'

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Limit'
          div className: 'col-md-4',
            input
              className: 'form-control'
              placeholder: 'optional, e.g. 100'
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
          label className: 'col-md-2 control-label',
            'Mapping'
            ExportHelp
              message: 'Mapping to define structure of exported tables. Has to be valid JSON.'
          div className: 'col-md-10',
            CodeMirror
              placeholder: ('e.g. {"_id.$oid": "id", "name": "name"}')
              value: @props.query.get('newMapping')
              onChange: @_handleMappingChange
              mode: 'application/json'
              lint: true
              lineWrapping: true
              lineNumbers: true
              theme: 'solarized'
