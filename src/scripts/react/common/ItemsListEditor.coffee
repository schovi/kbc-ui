React = require 'react'
ImmutableRenderMixin = require '../mixins/ImmutableRendererMixin'
_ = require('underscore')
Immutable = require('immutable')
{Button} = require('react-bootstrap')
Button = React.createFactory Button
{span} = React.DOM

module.exports = React.createClass
  displayName: 'ItemsListEditor'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    input: React.PropTypes.string
    inputPlaceholder: React.PropTypes.string
    emptyText: React.PropTypes.string
    onChangeValue: React.PropTypes.func.isRequired
    onChangeInput: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    inputPlaceholder: 'Add ...'
    emptyText: 'No packages will be installed'

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
    React.DOM.div {className: "well"},
      @props.value.map((packageName, key) ->
        React.DOM.span {key: key},
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
    React.DOM.div {className: "row"},
      React.DOM.div {className: "col-xs-4 form-inline kbc-inline-edit"},
        React.DOM.input
          className: "form-control"
          type: "text"
          name: "addPackage"
          placeholder: @props.inputPlaceholder
          onChange: @_handleOnChangeInput
          value: @props.input
          disabled: @props.disabled
        span className: 'kbc-inline-edit-buttons kbc-inline-edit-button',
          Button
            className: 'kbc-inline-edit-submit'
            bsStyle: "success"
            onClick: @_handleClickAddButton
            disabled: @props.disabled || @props.input.trim() == ''
          ,
            React.DOM.span {className: "kbc-icon-plus"}

  render: ->
    React.DOM.div {},
      if (@props.value.count())
        @_renderLabels()
      else
        React.DOM.div {className: "well"},
          React.DOM.small {},
            @props.emptyText
      @_renderAddInput()
