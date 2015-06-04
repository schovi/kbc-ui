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
    React.DOM.div {},
      React.DOM.div {className: "pull-right"},
        React.DOM.button
          className: "btn btn-success"
          onClick: (e) ->
            component.props.onAddOutputMapping()
            e.preventDefault()
        ,
          React.DOM.span {className: 'kbc-icon-plus'}
      React.DOM.h2 null, 'Output Mapping'
      if @props.value.count()
        @props.value.map(
          (mapping, key) ->
            Panel
              key: key
              collapsible: true
              expanded: component.props.openOutputMappings.get(key, false)
              eventKey: key
              onSelect: (event, key) ->
                component.props.toggleOpenOutputMapping(key)
                event.preventDefault()
              header:
                React.DOM.div className: '',
                  React.DOM.div className: 'row',
                    React.DOM.div className: 'col-xs-1',
                      React.DOM.strong null, "\##{key + 1}"
                    React.DOM.div className: 'col-xs-10',
                      React.DOM.strong null,
                        if mapping.get("source") then mapping.get("source") else "Undefined"
                        React.DOM.span {className: 'kbc-icon-arrow-right'}
                        if mapping.get("destination") then mapping.get("destination") else "Undefined"
                    React.DOM.div className: 'col-xs-1 text-right',
                      React.DOM.button className: 'btn btn-link',
                        React.DOM.span className: 'kbc-icon-cup'
            ,
              OutputMappingRowEditor
                fill: true
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
