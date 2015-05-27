React = require 'react'
Immutable = require 'immutable'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
_ = require('underscore')
OutputMappingRowEditor = React.createFactory(require './OutputMappingRowEditor')
Panel  = React.createFactory require('react-bootstrap').Panel

module.exports = React.createClass
  displayName: 'OutputMappingEditorContainer'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    backend: React.PropTypes.string.isRequired
    type: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired
    openOutputMappings: React.PropTypes.object.isRequired
    toggleOpenOutputMapping: React.PropTypes.func.isRequired
    onAddOutputMapping: React.PropTypes.func.isRequired
    onDeleteOutputMapping: React.PropTypes.func.isRequired

  _handleOnChange: (value) ->
    @props.onChange(value)

  _handleChangeOutputMapping: (key, mapping) ->
    value = @props.value.set(key, mapping)
    @props.onChange(value)

  render: ->
    component = @
    React.DOM.span {},
      React.DOM.div {className: "row col-md-12 text-right"},
        React.DOM.button
          className: "btn btn-success"
          onClick: (e) ->
            component.props.onAddOutputMapping()
            e.preventDefault()
        ,
          React.DOM.span {className: 'fa fa-plus fa-fw'}
          " Add Output Mapping"
      if @props.value.count()
        @props.value.map(
          (mapping, key) ->
            Panel
              key: key
              collapsable: true
              expanded: component.props.openOutputMappings.get(key, false)
              eventKey: key
              onSelect: (event, key) ->
                component.props.toggleOpenOutputMapping(key)
                event.preventDefault()
              header:
                React.DOM.div {},
                  "Output Mapping \##{key + 1} ("
                  if mapping.get("source") then mapping.get("source") else "Undefined"
                  React.DOM.span {className: 'fa fa-chevron-right fa-fw'}
                  if mapping.get("destination") then mapping.get("destination") else "Undefined"
                  ")"
            ,
              OutputMappingRowEditor
                value: mapping
                tables: component.props.tables
                onChange: (value) ->
                  component._handleChangeOutputMapping(key, value)
                onDelete: ->
                  component.props.onDeleteOutputMapping(key)
                disabled: component.props.disabled
                backend: component.props.backend
                type: component.props.type
        ).toArray()
