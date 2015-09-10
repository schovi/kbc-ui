React = require 'react'
Immutable = require 'immutable'
ImmutableRenderMixin = require '../../../../../../react/mixins/ImmutableRendererMixin'
RedshiftDataTypes = React.createFactory(require('./RedshiftDataTypes'))
_ = require('underscore')

module.exports = React.createClass
  displayName: 'RedshiftDataTypesContainer'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    columnsOptions: React.PropTypes.array.isRequired
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  getInitialState: ->
    column: ""
    datatype: ""
    size: ""
    compression: ""

  _handleColumnOnChange: (value) ->
    @setState
      column: value
      size: ""
      compression: ""

  _handleDataTypeOnChange: (value) ->
    @setState
      datatype: value
      size: ""
      compression: ""

  _handleSizeOnChange: (value) ->
    @setState
      size: value

  _handleCompressionOnChange: (value) ->
    @setState
      compression: value

  _handleAddDataType: ->
    datatypeString = @state.datatype
    if @state.size
      datatypeString += " (#{@state.size})"
    if @state.compression
      datatypeString += " ENCODE #{@state.compression}"
    value = @props.value.set(@state.column, datatypeString)
    @props.onChange(value)
    @setState
      column: ""
      datatype: ""
      size: ""
      compression: ""

  _handleRemoveDataType: (key) ->
    value = @props.value.remove(key)
    @props.onChange(value)

  _datatypesMap:
    SMALLINT:
      name: "SMALLINT",
      size: false,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT", "LZO", "DELTA", "MOSTLY8"]
    INTEGER:
      name: "INTEGER",
      size: false,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT", "LZO", "DELTA", "DELTA32K", "MOSTLY8", "MOSTLY16"]
    BIGINT:
      name: "BIGINT",
      size: false,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT", "LZO", "DELTA", "DELTA32K", "MOSTLY8", "MOSTLY16", "MOSTLY32"]
    DECIMAL:
      name: "DECIMAL",
      size: true,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT", "LZO", "DELTA32K", "MOSTLY8", "MOSTLY16", "MOSTLY32"]
    REAL:
      name: "REAL",
      size: false,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT"]
    "DOUBLE PRECISION":
      name: "DOUBLE PRECISION",
      size: false,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT"]
    "BOOLEAN":
      name: "BOOLEAN",
      size: false,
      compression: ["RAW", "RUNLENGTH"]
    "CHAR":
      name: "CHAR",
      size: true,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT", "LZO"]
    "VARCHAR":
      name: "VARCHAR",
      size: true,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT", "LZO", "TEXT255", "TEXT32K"]
    "DATE":
      name: "DATE",
      size: false,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT", "DELTA", "DELTA32K"]
    "TIMESTAMP":
      name: "TIMESTAMP",
      size: false,
      compression: ["RAW", "RUNLENGTH", "BYTEDICT", "DELTA", "DELTA32K"]

  _getDatatypeOptions: ->
    _.keys(@_datatypesMap)

  render: ->
    component = @
    RedshiftDataTypes
      datatypes: @props.value
      columnValue: @state.column
      datatypeValue: @state.datatype
      sizeValue: @state.size
      compressionValue: @state.compression
      datatypeOptions: @_getDatatypeOptions()
      showSize: if @state.datatype then @_datatypesMap[@state.datatype].size else false
      compressionOptions: if @state.datatype then @_datatypesMap[@state.datatype].compression else []
      columnsOptions: @props.columnsOptions
      columnOnChange: @_handleColumnOnChange
      datatypeOnChange: @_handleDataTypeOnChange
      sizeOnChange: @_handleSizeOnChange
      compressionOnChange: @_handleCompressionOnChange
      handleAddDataType: @_handleAddDataType
      handleRemoveDataType: @_handleRemoveDataType
      disabled: @props.disabled
