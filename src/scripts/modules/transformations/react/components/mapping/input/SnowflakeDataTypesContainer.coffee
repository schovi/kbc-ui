React = require 'react'
Immutable = require 'immutable'
ImmutableRenderMixin = require '../../../../../../react/mixins/ImmutableRendererMixin'
SnowflakeDataTypes = React.createFactory(require('./SnowflakeDataTypes'))
_ = require('underscore')

module.exports = React.createClass
  displayName: 'SnowflakeDataTypesContainer'
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

  _handleColumnOnChange: (value) ->
    @setState
      column: value
      size: ""

  _handleDataTypeOnChange: (value) ->
    @setState
      datatype: value
      size: ""

  _handleSizeOnChange: (value) ->
    @setState
      size: value

  _handleAddDataType: ->
    datatypeString = @state.datatype
    if @state.size
      datatypeString += " (#{@state.size})"
    value = @props.value.set(@state.column, datatypeString)
    @props.onChange(value)
    @setState
      column: ""
      datatype: ""
      size: ""

  _handleRemoveDataType: (key) ->
    value = @props.value.remove(key)
    @props.onChange(value)

  _datatypesMap:
    NUMBER:
      name: "NUMBER",
      size: true
    VARCHAR:
      name: "VARCHAR",
      size: true,
    DATE:
      name: "DATE",
      size: false
    TIMESTAMP:
      name: "TIMESTAMP",
      size: false
    TIMESTAMP_LTZ:
      name: "TIMESTAMP_LTZ",
      size: false
    TIMESTAMP_NTZ:
      name: "TIMESTAMP_NTZ",
      size: false
    TIMESTAMP_TZ:
      name: "TIMESTAMP_TZ",
      size: false

  _getDatatypeOptions: ->
    _.keys(@_datatypesMap)

  render: ->
    component = @
    SnowflakeDataTypes
      datatypes: @props.value
      columnValue: @state.column
      datatypeValue: @state.datatype
      sizeValue: @state.size
      datatypeOptions: @_getDatatypeOptions()
      showSize: if @state.datatype then @_datatypesMap[@state.datatype].size else false
      columnsOptions: @props.columnsOptions
      columnOnChange: @_handleColumnOnChange
      datatypeOnChange: @_handleDataTypeOnChange
      sizeOnChange: @_handleSizeOnChange
      handleAddDataType: @_handleAddDataType
      handleRemoveDataType: @_handleRemoveDataType
      disabled: @props.disabled
