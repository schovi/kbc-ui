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
    buckets: React.PropTypes.object.isRequired
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

  _renderAddButton: ->
    component = @
    React.DOM.button
      className: "btn btn-success"
      onClick: (e) ->
        component.props.onAddOutputMapping()
        e.preventDefault()
    ,
      React.DOM.span {className: 'kbc-icon-plus'}
      " Add"

  render: ->
    component = @
    React.DOM.div {},
      if !@props.value.count()
        React.DOM.div className: 'pull-right',
          @_renderAddButton()
      React.DOM.h2 null, 'Output Mapping'
        @props.value.map(
          (mapping, key) ->
            Panel
              className: 'kbc-panel-heading-with-table'
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
                      React.DOM.button
                        className: 'btn btn-link'
                        onClick: (e) ->
                          component.props.onDeleteOutputMapping(key)
                          e.preventDefault()
                      ,
                        React.DOM.span className: 'kbc-icon-cup'
            ,
              OutputMappingRowEditor
                fill: true
                value: mapping
                tables: component.props.tables
                buckets: component.props.buckets
                onChange: (value) ->
                  component._handleChangeOutputMapping(key, value)
                disabled: component.props.disabled
                backend: component.props.backend
                type: component.props.type

        ).toArray()
      if @props.value.count()
        React.DOM.div {className: "text-right"},
          @_renderAddButton()
