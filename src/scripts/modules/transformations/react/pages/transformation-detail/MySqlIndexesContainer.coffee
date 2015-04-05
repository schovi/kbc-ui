React = require 'react'
Immutable = require 'immutable'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
MySqlIndexes = React.createFactory(require('./MySqlIndexes'))
_ = require('underscore')

module.exports = React.createClass
  displayName: 'MySqlIndexesContainer'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    columnsOptions: React.PropTypes.array.isRequired
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  getInitialState: ->
    selectValue: Immutable.List()

  _handleSelectOnChange: (value) ->
    @setState
      selectValue: Immutable.fromJS(value)

  _handleAddIndex: ->
    value = @props.value.push(@state.selectValue)
    @props.onChange(value)
    @setState
      selectValue: Immutable.List()

  _handleRemoveIndex: (key) ->
    value = @props.value.remove(key)
    @props.onChange(value)

  render: ->
    component = @
    MySqlIndexes
      indexes: @props.value
      selectValue: @state.selectValue
      columnsOptions: @props.columnsOptions
      selectOnChange: @_handleSelectOnChange
      handleAddIndex: @_handleAddIndex
      handleRemoveIndex: @_handleRemoveIndex
      disabled: @props.disabled
