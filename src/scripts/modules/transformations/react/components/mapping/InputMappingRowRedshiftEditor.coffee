React = require 'react'
_ = require('underscore')
Immutable = require('immutable')
{Input} = require('react-bootstrap')
Input = React.createFactory Input
Select = React.createFactory require('../../../../../react/common/Select').default
RedshiftDataTypesContainer = React.createFactory(require("./input/RedshiftDataTypesContainer"))


module.exports = React.createClass
  displayName: 'InputMappingRowRedshiftEditor'

  propTypes:
    value: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired
    initialShowDetails: React.PropTypes.bool.isRequired
    isDestinationDuplicate: React.PropTypes.bool.isRequired

  getInitialState: ->
    showDetails: @props.initialShowDetails

  shouldComponentUpdate: (nextProps, nextState) ->
    should = @props.value != nextProps.value ||
    @props.tables != nextProps.tables ||
    @props.disabled != nextProps.disabled ||
    @state.showDetails != nextState.showDetails

    should

  _handleToggleShowDetails: (e) ->
    @setState(
      showDetails: e.target.checked
    )

  distStyleOptions: [
      label: "EVEN"
      value: "EVEN"
    ,
      label: "KEY"
      value: "KEY"
    ,
      label: "ALL"
      value: "ALL"
  ]

  _handleChangeSource: (value) ->
    # use only table name from the table identifier
    destination = value.substr(value.lastIndexOf(".") + 1)
    immutable = @props.value.withMutations (mapping) ->
      mapping = mapping.set("source", value)
      mapping = mapping.set("destination", destination)
      mapping = mapping.set("persistent", false)
      mapping = mapping.set("type", "table")
      mapping = mapping.set("datatypes", Immutable.Map())
      mapping = mapping.set("whereColumn", "")
      mapping = mapping.set("whereValues", Immutable.List())
      mapping = mapping.set("whereOperator", "eq")
      mapping = mapping.set("columns", Immutable.List())
      mapping = mapping.set("sortKey", "")
      mapping = mapping.set("distKey", "")
      mapping = mapping.set("copyOptions", "NULL AS 'NULL', ACCEPTANYDATE, TRUNCATECOLUMNS")
    @props.onChange(immutable)

  _handleChangeDestination: (e) ->
    value = @props.value.set("destination", e.target.value)
    @props.onChange(value)

  _handleChangeOptional: (e) ->
    value = @props.value.set("optional", e.target.value)
    @props.onChange(value)

  _handleChangePersistent: (e) ->
    value = @props.value.set("persistent", e.target.value)
    @props.onChange(value)

  _handleChangeType: (e) ->
    value = @props.value.set("type", e.target.value)
    @props.onChange(value)

  _handleChangeDays: (e) ->
    value = @props.value.set("days", parseInt(e.target.value))
    @props.onChange(value)

  _handleChangeColumns: (newValue) ->
    component = @
    immutable = @props.value.withMutations (mapping) ->
      mapping = mapping.set("columns", newValue)
      if newValue.count()

        columns = mapping.get("columns").toJS()
        if !_.contains(columns, mapping.get("whereColumn"))
          mapping = mapping.set("whereColumn", "")
          mapping = mapping.set("whereValues", Immutable.List())
          mapping = mapping.set("whereOperator", "eq")

        datatypes = _.pick(mapping.get("datatypes").toJS(), columns)
        mapping = mapping.set("datatypes", Immutable.fromJS(datatypes || Immutable.Map()))

        if !_.contains(columns, mapping.get("distKey"))
          mapping = mapping.set("distKey", "")
          mapping = mapping.set("distStyle", "")

        mapping = mapping.set("sortKey", _.intersection(
          columns,
          component.props.value.get("sortKey").split(",")
        ).join(","))

    @props.onChange(immutable)

  _handleChangeWhereColumn: (string) ->
    value = @props.value.set("whereColumn", string)
    @props.onChange(value)

  _handleChangeWhereOperator: (e) ->
    value = @props.value.set("whereOperator", e.target.value)
    @props.onChange(value)

  _handleChangeWhereValues: (newValue) ->
    value = @props.value.set("whereValues", newValue)
    @props.onChange(value)

  _handleChangeDataTypes: (datatypes) ->
    value = @props.value.set("datatypes", datatypes)
    @props.onChange(value)

  _handleChangeSortKey: (immutable, string) ->
    value = @props.value.set("sortKey", string)
    @props.onChange(value)

  _handleChangeDistKey: (string) ->
    value = @props.value.set("distKey", string)
    @props.onChange(value)

  _handleChangeDistStyle: (string) ->
    value = @props.value.set("distStyle", string)
    @props.onChange(value)

  _handleChangeCopyOptions: (e) ->
    value = @props.value.set("copyOptions", e.target.value)
    @props.onChange(value)

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
    return [] if !table
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
    if @props.value.get("columns", Immutable.List()).count()
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

  _isSourceTableRedshift: ->
    props = @props
    table = @props.tables.find((table) ->
      table.get("id") == props.value.get("source")
    )
    if !table
      return false
    else
      return table.getIn(["bucket", "backend"]) == "redshift"

  _getSortKeyImmutable: ->
    if @props.value.get("sortKey")
      Immutable.fromJS(@props.value.get("sortKey").split(","))
    else
      Immutable.List()

  render: ->
    component = @
    React.DOM.div {className: 'form-horizontal clearfix'},
      React.DOM.div {className: "row col-md-12"},
        React.DOM.div className: 'form-group form-group-sm',
          React.DOM.div className: 'col-xs-10 col-xs-offset-2',
            Input
              standalone: true
              type: 'checkbox'
              label: React.DOM.small {}, 'Show details'
              checked: @state.showDetails
              onChange: @_handleToggleShowDetails

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
            if @state.showDetails
              Input
                standalone: true
                type: 'checkbox'
                label: React.DOM.small {}, 'Optional'
                value: @props.value.get("optional")
                disabled: @props.disabled
                onChange: @_handleChangeOptional
                help: React.DOM.small {},
                  "If this table does not exist in Storage, the transformation won't show an error."
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
          bsStyle: if @props.isDestinationDuplicate then 'error' else null
          help: if @props.isDestinationDuplicate then React.DOM.small {'className': 'error'},
              'Duplicate destination '
              React.DOM.code {}, @props.value.get("destination")
              '.'
            else null
      if @state.showDetails && @_isSourceTableRedshift()
        React.DOM.div {className: "row col-md-12"},
          Input
            bsSize: 'small'
            type: 'select'
            name: 'type'
            label: 'Type'
            value: @props.value.get("type", "table")
            disabled: @props.disabled
            onChange: @_handleChangeType
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-10'
            help:
              React.DOM.small {},
                React.DOM.span {},
                  React.DOM.div {},
                   React.DOM.code {}, "table"
                   "Input mapping is created as a physical table, takes longer to process"
                  React.DOM.div {},
                   React.DOM.code {}, "view"
                   "Input mapping is created as a view, will consume more memory when materializing"
          ,
            React.DOM.option {value: "table"}, "Table"
            React.DOM.option {value: "view"}, "View"
      if @state.showDetails && (!@_isSourceTableRedshift() || @props.value.get("type") == 'table')
        React.DOM.div {className: "row col-md-12"},
          Input
            bsSize: 'small'
            type: 'checkbox'
            label: React.DOM.small {}, 'Persistent'
            value: @props.value.get("persistent")
            disabled: @props.disabled
            onChange: @_handleChangePersistent
            wrapperClassName: 'col-xs-offset-2 col-xs-10'
            help: React.DOM.small {},
              "Try to keep the table in Redshift DB. STATUPDATE and COMPUPDATE
              will be processed only in the first run."
      if @state.showDetails
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
              React.DOM.div
                className: "help-block"
              ,
                React.DOM.small {}, "Import only specified columns"
      if @state.showDetails
        Input
          bsSize: 'small'
          type: 'number'
          label: 'Days'
          value: @props.value.get("days")
          disabled: @props.disabled
          placeholder: 0
          help: React.DOM.small {},
            "Data updated in the given period"
          onChange: @_handleChangeDays
          labelClassName: 'col-xs-2'
          wrapperClassName: 'col-xs-4'
      if @state.showDetails
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
                bsSize: 'small'
                type: 'select'
                name: 'whereOperator'
                value: @props.value.get("whereOperator")
                disabled: @props.disabled
                onChange: @_handleChangeWhereOperator
              ,
                React.DOM.option {value: "eq"}, "= (IN)"
                React.DOM.option {value: "ne"}, "!= (NOT IN)"
            React.DOM.div className: 'col-xs-4',
              Select
                name: 'whereValues'
                value: @props.value.get('whereValues')
                multi: true
                disabled: @props.disabled
                allowCreate: true
                delimiter: ','
                placeholder: 'Add a value...'
                emptyStrings: true,
                onChange: @_handleChangeWhereValues
      if @state.showDetails && (!@_isSourceTableRedshift() || @props.value.get("type") == 'table')
        React.DOM.div {className: "row col-md-12"},
          React.DOM.div className: 'form-group form-group-sm',
            React.DOM.label className: 'col-xs-2 control-label', 'Data types'
            React.DOM.div className: 'col-xs-10',
              RedshiftDataTypesContainer
                value: @props.value.get("datatypes", Immutable.Map())
                disabled: @props.disabled || !@props.value.get("source")
                onChange: @_handleChangeDataTypes
                columnsOptions: @_getFilteredColumnsOptions()
      if @state.showDetails && (!@_isSourceTableRedshift() || @props.value.get("type") == 'table')
        React.DOM.div {className: "row col-md-12"},
          React.DOM.div className: 'form-group form-group-sm',
            React.DOM.label className: 'col-xs-2 control-label', 'Sort Key'
            React.DOM.div className: 'col-xs-10',
              Select
                multi: true
                name: 'sortKey'
                value: @_getSortKeyImmutable()
                disabled: @props.disabled || !@props.value.get("source")
                placeholder: "No sortkey"
                onChange: @_handleChangeSortKey
                options: @_getFilteredColumnsOptions()
              React.DOM.div className: "help-block",
                React.DOM.small {},
                  "SORTKEY option for creating table in Redshift DB.
                    You can create a compound sort key."
      if @state.showDetails && (!@_isSourceTableRedshift() || @props.value.get("type") == 'table')
        React.DOM.div {className: "row col-md-12"},
          React.DOM.div className: 'form-group form-group-sm',
            React.DOM.label className: 'col-xs-2 control-label', 'Dist Key'
            React.DOM.div className: 'col-xs-7',
              Select
                name: 'distKey'
                value: @props.value.get("distKey")
                disabled: @props.disabled || !@props.value.get("source")
                placeholder: "Select column"
                onChange: @_handleChangeDistKey
                options: @_getFilteredColumnsOptions()
            React.DOM.div className: 'col-xs-3',
              Select
                name: 'distStyle'
                value: @props.value.get("distStyle")
                disabled: @props.disabled || !@props.value.get("source")
                placeholder: "Style"
                onChange: @_handleChangeDistStyle
                options: @distStyleOptions

            React.DOM.div
              className: "col-xs-offset-2 col-xs-10 help-block"
            ,
              React.DOM.small {},
                "DISTKEY and DISTSTYLE options used for
                  CREATE TABLE query in Redshift."

      if @state.showDetails && (!@_isSourceTableRedshift())
        React.DOM.div {className: "row col-md-12"},
          Input
            bsSize: 'small'
            type: 'text'
            label: 'COPY options'
            value: @props.value.get("copyOptions")
            disabled: @props.disabled
            placeholder: "NULL AS 'NULL', ACCEPTANYDATE, TRUNCATECOLUMNS"
            onChange: @_handleChangeCopyOptions
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-10'
            help:
              React.DOM.small {},
                "Additional options for COPY command, multiple values separated by comma. "
                React.DOM.a
                  href: "http://wiki.keboola.com/home/keboola-connection/devel-space/
                    transformations/backends/redshift#COPY_command"
                ,
                  "Default options"
                "."
