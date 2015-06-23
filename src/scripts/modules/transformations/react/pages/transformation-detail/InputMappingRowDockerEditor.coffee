React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
_ = require('underscore')
Immutable = require('immutable')
{Input} = require('react-bootstrap')
Input = React.createFactory Input
Select = React.createFactory(require('react-select'))
MySqlIndexesContainer = React.createFactory(require("./MySqlIndexesContainer"))
MySqlDataTypesContainer = React.createFactory(require("./MySqlDataTypesContainer"))

module.exports = React.createClass
  displayName: 'InputMappingRowDockjerEditor'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  _handleChangeSource: (value) ->
    immutable = @props.value.withMutations (mapping) ->
      mapping = mapping.set("source", value)
      mapping = mapping.set("destination", value)
      mapping = mapping.set("whereColumn", "")
      mapping = mapping.set("whereValues", Immutable.List())
      mapping = mapping.set("whereOperator", "eq")
      mapping = mapping.set("columns", Immutable.List())
    @props.onChange(immutable)

  _handleChangeDestination: (e) ->
    value = @props.value.set("destination", e.target.value)
    @props.onChange(value)

  _handleChangeDays: (e) ->
    value = @props.value.set("days", parseInt(e.target.value))
    @props.onChange(value)

  _handleChangeColumns: (string, array) ->
    immutable = @props.value.withMutations (mapping) ->
      mapping = mapping.set("columns", Immutable.fromJS(_.pluck(array, "value")))
      if !_.contains(mapping.get("columns").toJS(), mapping.get("whereColumn"))
        mapping = mapping.set("whereColumn", "")
        mapping = mapping.set("whereValues", Immutable.List())
        mapping = mapping.set("whereOperator", "eq")
    @props.onChange(immutable)

  _handleChangeWhereColumn: (string) ->
    value = @props.value.set("whereColumn", string)
    @props.onChange(value)

  _handleChangeWhereOperator: (e) ->
    value = @props.value.set("whereOperator", e.target.value)
    @props.onChange(value)

  _handleChangeWhereValues: (e) ->
    parsedValues = _.invoke(e.target.value.split(","), "trim")
    value = @props.value.set("whereValues", Immutable.fromJS(parsedValues))
    @props.onChange(value)

  _getWhereValues: ->
    @props.value.get("whereValues", Immutable.List()).join(",")

  _getTables: ->
    props = @props
    inOutTables = @props.tables.filter((table) ->
      table.get("id").substr(0, 3) == "in." || table.get("id").substr(0, 4) == "out."
    )
    map = inOutTables.map((table) ->
      {
        label: table.get("id")
        value: table.get("id")
      }
    )
    map.toList().sort( (valA, valB) ->
      return 1 if valA.label > valB.label
      return -1 if valA.label < valB.label
      return 0
    ).toJS()

  _getColumns: ->
    if !@props.value.get("source")
      return []
    props = @props
    table = @props.tables.find((table) ->
      table.get("id") == props.value.get("source")
    )
    table.get("columns").toJS()

  _getColumnsOptions: ->
    columns = @_getColumns()
    map = _.map(
      columns, (column) ->
        {
          label: column
          value: column
        }
    )

  _getFilteredColumnsOptions: ->
    if @props.value.get("columns").count()
      columns = @props.value.get("columns").toJS()
    else
      columns = @_getColumns()
    _.map(
      columns, (column) ->
        {
          label: column
          value: column
        }
    )

  render: ->
    component = @
    React.DOM.div {},
      React.DOM.div {className: "row col-md-12"},
        React.DOM.div className: 'form-group',
          React.DOM.label className: 'col-xs-2 control-label', 'Source'
          React.DOM.div className: 'col-xs-10',
            Select
              name: 'source'
              value: @props.value.get("source")
              disabled: @props.disabled
              placeholder: "Source table"
              onChange: @_handleChangeSource
              options: @_getTables()
      React.DOM.div {className: "row col-md-12"},
        Input
          bsSize: 'small'
          type: 'text'
          label: 'File'
          value: @props.value.get("destination")
          disabled: @props.disabled
          placeholder: "File name"
          onChange: @_handleChangeDestination
          labelClassName: 'col-xs-2'
          wrapperClassName: 'col-xs-10'
          help: React.DOM.small {},
            "File will be downloaded to"
            React.DOM.code {}, "/data/in/tables"
      React.DOM.div {className: "row col-md-12"},
        React.DOM.div className: 'form-group form-group-sm',
          React.DOM.label className: 'col-xs-2 control-label', 'Columns'
          React.DOM.div className: 'col-xs-10',
            Select
              multi: true
              name: 'columns'
              value: @props.value.get("columns", Immutable.List()).toJS()
              disabled: @props.disabled || !@props.value.get("source")
              placeholder: "All columns will be imported"
              onChange: @_handleChangeColumns
              options: @_getColumnsOptions()
            React.DOM.small
              className: "help-block"
            ,
              "Import only specified columns"
        Input
          bsSize: 'small'
          type: 'number'
          label: 'Days'
          value: @props.value.get("days")
          disabled: @props.disabled
          placeholder: 0
          help: React.DOM.small {}, "Data updated in the given period"
          onChange: @_handleChangeDays
          labelClassName: 'col-xs-2'
          wrapperClassName: 'col-xs-5'
      React.DOM.div {className: "row col-md-12"},
        React.DOM.div className: 'form-group form-group-sm',
          React.DOM.label className: 'col-xs-2 control-label', 'Data filter'
          React.DOM.div className: 'col-xs-4',
            Select
              name: 'whereColumn'
              value: @props.value.get("whereColumn")
              disabled: @props.disabled || !@props.value.get("source")
              placeholder: "Select column"
              onChange: @_handleChangeWhereColumn
              options: @_getColumnsOptions()
          React.DOM.div className: 'col-xs-2',
            Input
              type: 'select'
              name: 'whereOperator'
              value: @props.value.get("whereOperator")
              disabled: @props.disabled
              onChange: @_handleChangeWhereOperator
            ,
              React.DOM.option {value: "eq"}, "= (IN)"
              React.DOM.option {value: "ne"}, "!= (NOT IN)"
          React.DOM.div className: 'col-xs-4',
            Input
              type: 'text'
              name: 'whereValues'
              value: @_getWhereValues()
              disabled: @props.disabled
              onChange: @_handleChangeWhereValues
              placeholder: "Comma separated values"
