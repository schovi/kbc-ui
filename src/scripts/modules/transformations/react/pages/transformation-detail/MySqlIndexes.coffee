React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
{Button} = require('react-bootstrap')
Button = React.createFactory Button
Select = React.createFactory(require('react-select'))
_ = require('underscore')

module.exports = React.createClass
  displayName: 'MySqlIndexes'
  mixins: [ImmutableRenderMixin]

  propTypes:
    indexes: React.PropTypes.object.isRequired
    selectValue: React.PropTypes.object.isRequired
    columnsOptions: React.PropTypes.array.isRequired
    disabled: React.PropTypes.bool.isRequired
    selectOnChange: React.PropTypes.func.isRequired
    handleAddIndex: React.PropTypes.func.isRequired
    handleRemoveIndex: React.PropTypes.func.isRequired

  _handleSelectOnChange: (string, array) ->
    @props.selectOnChange(_.pluck(array, "value"))

  render: ->
    component = @
    React.DOM.span {},
      React.DOM.div {className: "row"},
        React.DOM.span {className: "col-xs-12"},
        if !@props.indexes.count()
          React.DOM.div {}, "No indexes set yet."
        else
          React.DOM.div {className: "tags-list"}
          @props.indexes.map((index, key) ->
            React.DOM.span {key: key},
              React.DOM.span {className: 'label label-default'},
                index.toArray().join(', ')
                React.DOM.span
                  className: "kbc-icon-cup"
                  onClick: ->
                    component.props.handleRemoveIndex(key)
              ' '
          , @).toArray()
      React.DOM.div {className: "row"},
        React.DOM.span {className: "col-xs-10"},
          Select
            multi: true
            name: 'add-indexes'
            value: @props.selectValue.toJS()
            disabled: @props.disabled
            placeholder: "Select column(s) to create an index"
            onChange: @_handleSelectOnChange
            options: @props.columnsOptions
        React.DOM.span {className: "col-xs-2"},
          Button
            onClick: @props.handleAddIndex
            disabled: @props.disabled || @props.selectValue.count() == 0
          ,
            React.DOM.i {className: "kbc-icon-plus"}
            " Add"
