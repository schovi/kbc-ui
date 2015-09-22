React = require 'react'
ImmutableRenderMixin = require '../../../../../../react/mixins/ImmutableRendererMixin'
{Input, Button, ListGroup, ListGroupItem} = require('react-bootstrap')
Input = React.createFactory Input
Button = React.createFactory Button
ListGroup = React.createFactory ListGroup
ListGroupItem = React.createFactory ListGroupItem
Select = React.createFactory(require('react-select'))
_ = require('underscore')

module.exports = React.createClass
  displayName: 'MySqlDataTypes'
  mixins: [ImmutableRenderMixin]

  propTypes:
    datatypes: React.PropTypes.object.isRequired
    selectValue: React.PropTypes.string.isRequired
    inputValue: React.PropTypes.string.isRequired
    columnsOptions: React.PropTypes.array.isRequired
    disabled: React.PropTypes.bool.isRequired
    selectOnChange: React.PropTypes.func.isRequired
    inputOnChange: React.PropTypes.func.isRequired
    handleAddDataType: React.PropTypes.func.isRequired
    handleRemoveDataType: React.PropTypes.func.isRequired

  _handleInputOnChange: (e) ->
    @props.inputOnChange(e.target.value)

  _getColumnsOptions: ->
    component = @
    _.filter(@props.columnsOptions, (option) ->
      !_.contains(_.keys(component.props.datatypes.toJS()), option.value)
    )

  render: ->
    component = @
    React.DOM.span {},
      React.DOM.div {className: "row"},
        React.DOM.span {className: "col-xs-12"},
        if !@props.datatypes.count()
          React.DOM.small {}, "No data types set yet."
        else
          ListGroup {},
            @props.datatypes.map((datatype, key) ->
              ListGroupItem {key: key},
                  React.DOM.small {},
                    React.DOM.strong {}, key
                    " "
                    React.DOM.span {}, datatype
                    React.DOM.i
                      className: "kbc-icon-cup kbc-cursor-pointer pull-right"
                      onClick: ->
                        component.props.handleRemoveDataType(key)
            , @).toArray()
      React.DOM.div {className: "row"},
        React.DOM.span {className: "col-xs-5"},
          Select
            name: 'add-datatype-column'
            value: @props.selectValue
            disabled: @props.disabled
            placeholder: "Select column"
            onChange: @props.selectOnChange
            options: @_getColumnsOptions()
        React.DOM.span {className: "col-xs-5"},
          Input
            type: 'text'
            name: 'add-datatype-value'
            value: @props.inputValue
            disabled: @props.disabled || !@props.selectValue
            placeholder: "Eg. VARCHAR(255)"
            onChange: @_handleInputOnChange
            autoComplete: 'off'
        React.DOM.span {className: "col-xs-2 kbc-col-button"},
          Button
            bsSize: 'small'
            onClick: @props.handleAddDataType
            disabled: @props.disabled || !@props.selectValue || !@props.inputValue
          ,
            React.DOM.i {className: "kbc-icon-plus"}
            " Add"
      React.DOM.div {className: "row", style: {paddingTop: "5px"}},
        React.DOM.div {className: "help-block col-xs-12"},
          React.DOM.small {},
            React.DOM.div {},
              React.DOM.code {}, "VARCHAR(255)"
              "default for primary key columns"
            React.DOM.div {},
              React.DOM.code {}, "TEXT"
              "default for all other columns"
