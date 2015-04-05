React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
_ = require('underscore')
Immutable = require('immutable')
{Button} = require('react-bootstrap')
Button = React.createFactory Button

module.exports = React.createClass
  displayName: 'PackagesEditor'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    input: React.PropTypes.string
    onChangeValue: React.PropTypes.func.isRequired
    onChangeInput: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  _handleOnChangeInput: (e) ->
    @props.onChangeInput(e.target.value)

  _handleClickAddButton: (e) ->
    values = @props.value.push(@props.input)
    values = Immutable.fromJS(_.unique(values.toArray()))
    @props.onChangeValue(values)
    _.defer(@props.onChangeInput, "")
    e.preventDefault()

  _handleClickRemoveButton: (key) ->
    values = @props.value.delete(key)
    @props.onChangeValue(values)

  _renderLabels: ->
    component = @
    React.DOM.div {className: "col-xs-10 col-xs-offset-2"},
      @props.value.map((packageName, key) ->
        React.DOM.span {},
          React.DOM.span {className: 'label label-default'},
            React.DOM.span
              className: "kbc-icon-cup"
              onClick: ->
                component._handleClickRemoveButton(key)
            ' '
            packageName
          ' '
      , @).toArray()

  _renderAddInput: ->
    component = @
    React.DOM.span {className: "form-group form-group-sm"},
      React.DOM.div {className: "col-xs-4 col-xs-offset-2"},
        React.DOM.input
          className: "form-control"
          type: "text"
          name: "addPackage"
          placeholder: "Add a package..."
          onChange: @_handleOnChangeInput
          value: @props.input
          disabled: @props.disabled
      React.DOM.div {className: "col-xs-6"},
        Button
          bsStyle: "success"
          onClick: @_handleClickAddButton
          disabled: @props.disabled || @props.input.trim() == ''
        ,
          React.DOM.i {className: "kbc-icon-plus"}
          " Add"

  render: ->
    React.DOM.span {},
      if (@props.value.count())
        React.DOM.span {},
          @_renderLabels()
      else
        React.DOM.div {className: "col-xs-4 col-xs-offset-2"},
          React.DOM.small {},
            'No packages will be installed'
      @_renderAddInput()
