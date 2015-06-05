React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
_ = require('underscore')
Immutable = require('immutable')
Input = React.createFactory require('react-bootstrap').Input
Select = React.createFactory(require('react-select'))
ReactTypeahead = React.createFactory(require('react-typeahead').Typeahead)

module.exports = React.createClass
  displayName: 'OutputMappingRowEditor'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired
    backend: React.PropTypes.string.isRequired
    type: React.PropTypes.string.isRequired

  _handleChangeSource: (e) ->
    immutable = @props.value.withMutations (mapping) ->
      mapping = mapping.set("source", e.target.value)
    @props.onChange(immutable)

  _handleChangeDestination: (newValue) ->
    value = @props.value.set("destination", newValue)
    @props.onChange(value)

  _handleChangeIncremental: (e) ->
    value = @props.value.set("incremental", e.target.value)
    @props.onChange(value)

  _handleChangePrimaryKey: (e) ->
    parsedValues = _.invoke(e.target.value.split(","), "trim")
    value = @props.value.set("primaryKey", Immutable.fromJS(parsedValues))
    @props.onChange(value)

  _handleChangeDeleteWhereColumn: (newValue) ->
    value = @props.value.set("deleteWhereColumn", newValue)
    @props.onChange(value)

  _handleChangeWhereOperator: (e) ->
    value = @props.value.set("deleteWhereOperator", e.target.value)
    @props.onChange(value)

  _handleChangeDeleteWhereValues: (e) ->
    parsedValues = _.invoke(e.target.value.split(","), "trim")
    value = @props.value.set("deleteWhereValues", Immutable.fromJS(parsedValues))
    @props.onChange(value)

  _getPrimaryKeyValue: ->
    @props.value.get("primaryKey", Immutable.List()).join(",")

  _getDeleteWhereValues: ->
    @props.value.get("deleteWhereValues", Immutable.List()).join(",")

  _getTables: ->
    props = @props
    inOutTables = @props.tables.filter((table) ->
      table.get("id").substr(0, 3) == "in." || table.get("id").substr(0, 4) == "out."
    )
    map = inOutTables.map((table) ->
      table.get("id")
    )
    map.toList().toJS()

  _getColumns: ->
    if !@props.value.get("destination")
      return []
    props = @props
    table = @props.tables.find((table) ->
      table.get("id") == props.value.get("destination")
    )
    if !table
      return []
    table.get("columns").toJS()

  render: ->
    component = @
    React.DOM.div {className: 'panel-body'},
      React.DOM.div {className: "row col-md-12"},
        if @props.backend == 'docker' && @props.type == 'r'
          Input
            type: 'text'
            name: 'source'
            label: 'File'
            value: @props.value.get("source")
            disabled: @props.disabled
            placeholder: "File name"
            onChange: @_handleChangeSource
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-10'
            help: React.DOM.span {},
              "File will be uploaded from"
              React.DOM.code {}, "/data/out/tables"
        else
          Input
            type: 'text'
            name: 'source'
            label: 'Source'
            value: @props.value.get("source")
            disabled: @props.disabled
            placeholder: "Source table in transformation DB"
            onChange: @_handleChangeSource
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-10'
      React.DOM.div {className: "row col-md-12"},
        React.DOM.div className: 'form-group',
          React.DOM.label className: 'col-xs-2 control-label', 'Destination'
          React.DOM.div className: 'col-xs-10',
            ReactTypeahead
              defaultValue: @props.value.get("destination", "")
              customClasses:
                input: 'form-control'
              onOptionSelected: @_handleChangeDestination
              options: @_getTables()
              placeholder: "Destination table in Storage"
              maxVisible: 10
      React.DOM.div {className: "row col-md-12"},
        Input
          name: 'incremental'
          type: 'checkbox'
          label: 'Incremental'
          value: @props.value.get("optional")
          disabled: @props.disabled
          onChange: @_handleChangeIncremental
          wrapperClassName: 'col-xs-offset-2 col-xs-10'
          help: "If the destination table exists in Storage API,
            output mapping does not overwrite the table, it only appends the data to it.
            Uses incremental write to Storage API."
      React.DOM.div {className: "row col-md-12"},
        Input
          name: 'primaryKey'
          type: 'text'
          label: 'Primary key'
          value: @_getPrimaryKeyValue()
          disabled: @props.disabled
          placeholder: "Column name(s)"
          onChange: @_handleChangePrimaryKey
          labelClassName: 'col-xs-2'
          wrapperClassName: 'col-xs-10'
          help: "Primary key of the table in Storage API. If the table already exists, primary key must match.
            Parts of a composite primary key are separated with a comma."

      React.DOM.div {className: "row col-md-12"},
        React.DOM.div className: 'form-group',
          React.DOM.label className: 'col-xs-2 control-label', 'Delete rows'
          React.DOM.div className: 'col-xs-4',
            ReactTypeahead
              defaultValue: @props.value.get("deleteWhereColumn", "")
              customClasses:
                input: 'form-control'
              onOptionSelected: @_handleChangeDeleteWhereColumn
              options: @_getColumns()
              placeholder: "Select column"
              maxVisible: 10
          React.DOM.div className: 'col-xs-2',
            Input
              type: 'select'
              name: 'deleteWhereOperator'
              value: @props.value.get("deleteWhereOperator")
              disabled: @props.disabled
              onChange: @_handleChangeDeleteWhereOperator
            ,
              React.DOM.option {value: "eq"}, "= (IN)"
              React.DOM.option {value: "ne"}, "!= (NOT IN)"
          React.DOM.div className: 'col-xs-4',
            Input
              type: 'text'
              name: 'deleteWhereValues'
              value: @_getDeleteWhereValues()
              disabled: @props.disabled
              onChange: @_handleChangeDeleteWhereValues
              placeholder: "Comma separated values"
