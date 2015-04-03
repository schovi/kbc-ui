React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
_ = require('underscore')
Immutable = require('immutable')
{Input} = require('react-bootstrap')
Input = React.createFactory Input
Select = React.createFactory(require('react-select'))

module.exports = React.createClass
  displayName: 'InputMappingRowMySqlEditor'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    onDelete: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  _handleChangeSource: (value) ->
    immutable = @props.value.withMutations (mapping) ->
      mapping = mapping.set("source", value)
      mapping = mapping.set("destination", value)
    @props.onChange(immutable)

  _handleChangeDestination: (e) ->
    value = @props.value.set("destination", e.target.value)
    @props.onChange(value)

  _handleChangeOptional: (e) ->
    value = @props.value.set("optional", e.target.value)
    @props.onChange(value)

  _handleChangeDays: (e) ->
    value = @props.value.set("days", parseInt(e.target.value))
    @props.onChange(value)

  _getTables: ->
    props = @props
    _.sortBy(
      _.map(
        _.filter(props.tables.toArray(), (table) ->
          table.getIn(["bucket", "id"]).substr(0, 3) == "in." || table.getIn(["bucket", "id"]).substr(0, 4) == "out."
        ), (table) -> {
          label: table.get("id")
          value: table.get("id")
        }
      ), (option) ->
        option.label.toLowerCase()
  )

  _getColumns: ->
    return []
    if !@props.value.get("source")
      return []
    ###
    props = @props
    table = _.find(
      @props.tables.toArray(), (table) ->
        table.get("id") == props.value.get("source")
    )
    console.log "table", table
    columns = _.map(
      table.get("columns"), (column) ->
        {
          label: column
          value: column
        }
    )
    console.log "columns", columns
    return columns
    ###


  render: ->
    console.log "render", @props.value.toJS()
    component = @
    React.DOM.div {},
      React.DOM.div {className: "row col-md-12"},
        React.DOM.h5 {}, "Mapping"
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
          type: 'checkbox'
          label: 'Optional'
          value: @props.value.get("optional")
          disabled: @props.disabled
          onChange: @_handleChangeOptional
          wrapperClassName: 'col-xs-offset-2 col-xs-10'
          help: "If this table does not exist in Storage, the transformation won't show an error."
      React.DOM.div {className: "row col-md-12"},
        Input
          type: 'text'
          label: 'Destination'
          value: @props.value.get("destination")
          disabled: @props.disabled
          placeholder: "Destination table name in transformation DB"
          onChange: @_handleChangeDestination
          labelClassName: 'col-xs-2'
          wrapperClassName: 'col-xs-10'

      React.DOM.div {className: "row col-md-12"},
        React.DOM.h5 {}, "Data Filters"

      React.DOM.div {className: "row col-md-12"},
        React.DOM.div className: 'form-group',
          React.DOM.label className: 'col-xs-2 control-label', 'Columns'
          React.DOM.div className: 'col-xs-10',
            Select
              multi: true
              name: 'columns'
              value: @props.value.get("columns", Immutable.List()).toArray()
              disabled: @props.disabled || !@props.value.get("source")
              placeholder: "All columns will be imported"
              onChange: @_handleChangeSource
              options: @_getColumns()
            React.DOM.div
              className: "help-block"
            ,
              "Import only specified columns"
        Input
          type: 'number'
          label: 'Days'
          value: @props.value.get("days")
          disabled: @props.disabled
          placeholder: 0
          help: "Data updated in the given period"
          onChange: @_handleChangeDays
          labelClassName: 'col-xs-2'
          wrapperClassName: 'col-xs-4'

      React.DOM.div {className: "row col-md-12"},
        React.DOM.h5 {}, "Indexes"

      React.DOM.div {className: "row col-md-12"},
        React.DOM.h5 {}, "Data Types"

      React.DOM.div {className: "row col-md-12 text-right"},
        React.DOM.button
          className: "btn btn-danger"
          onClick: (e) ->
            component.props.onDelete()
            e.preventDefault()
        ,
          " Delete input mapping"
