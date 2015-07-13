React = require 'react'
Immutable = require 'immutable'
ImmutableRenderMixin = require '../../../../../../react/mixins/ImmutableRendererMixin'
MySqlDataTypes = React.createFactory(require('./MySqlDataTypes'))
_ = require('underscore')

module.exports = React.createClass
  displayName: 'MySqlDataTypesContainer'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    columnsOptions: React.PropTypes.array.isRequired
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  getInitialState: ->
    selectValue: ""
    inputValue: ""

  _handleSelectOnChange: (value) ->
    @setState
      selectValue: value

  _handleInputOnChange: (value) ->
    @setState
      inputValue: value

  _handleAddDataType: ->
    value = @props.value.set(@state.selectValue, @state.inputValue)
    @props.onChange(value)
    @setState
      selectValue: ""
      inputValue: ""

  _handleRemoveDataType: (key) ->
    value = @props.value.remove(key)
    @props.onChange(value)

  render: ->
    component = @
    MySqlDataTypes
      datatypes: @props.value
      selectValue: @state.selectValue
      inputValue: @state.inputValue
      columnsOptions: @props.columnsOptions
      selectOnChange: @_handleSelectOnChange
      inputOnChange: @_handleInputOnChange
      handleAddDataType: @_handleAddDataType
      handleRemoveDataType: @_handleRemoveDataType
      disabled: @props.disabled
