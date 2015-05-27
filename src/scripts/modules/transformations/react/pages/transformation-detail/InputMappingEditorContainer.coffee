React = require 'react'
Immutable = require 'immutable'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
_ = require('underscore')
InputMappingRowMySqlEditor = React.createFactory(require './InputMappingRowMySqlEditor')
InputMappingRowDockerEditor = React.createFactory(require './InputMappingRowDockerEditor')
InputMappingRowRedshiftEditor = React.createFactory(require './InputMappingRowRedshiftEditor')
Panel  = React.createFactory require('react-bootstrap').Panel

module.exports = React.createClass
  displayName: 'InputMappingEditorContainer'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    backend: React.PropTypes.string.isRequired
    type: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired
    openInputMappings: React.PropTypes.object.isRequired
    toggleOpenInputMapping: React.PropTypes.func.isRequired
    onAddInputMapping: React.PropTypes.func.isRequired
    onDeleteInputMapping: React.PropTypes.func.isRequired

  _handleOnChange: (value) ->
    @props.onChange(value)

  _handleChangeInputMapping: (key, mapping) ->
    value = @props.value.set(key, mapping)
    @props.onChange(value)

  render: ->
    component = @
    React.DOM.span {},
      React.DOM.div {className: "row col-md-12 text-right"},
        React.DOM.button
          className: "btn btn-success"
          onClick: (e) ->
            component.props.onAddInputMapping()
            e.preventDefault()
        ,
          React.DOM.span {className: 'fa fa-plus fa-fw'}
          " Add Input Mapping"
      if @props.value.count()
        @props.value.map(
          (mapping, key) ->
            Panel
              key: key
              collapsible: true
              expanded: component.props.openInputMappings.get(key, false)
              eventKey: key
              onSelect: (event, key) ->
                component.props.toggleOpenInputMapping(key)
                event.preventDefault()
              header:
                React.DOM.div {},
                  "Input Mapping \##{key + 1} ("
                  if mapping.get("source") then mapping.get("source") else "Undefined"
                  React.DOM.span {className: 'fa fa-chevron-right fa-fw'}
                  if mapping.get("destination") then mapping.get("destination") else "Undefined"
                  ")"
            ,
              if component.props.backend == "mysql" && component.props.type == "simple"
                InputMappingRowMySqlEditor
                  value: mapping
                  tables: component.props.tables
                  onChange: (value) ->
                    component._handleChangeInputMapping(key, value)
                  onDelete: ->
                    component.props.onDeleteInputMapping(key)
                  disabled: component.props.disabled
              else if component.props.backend == "redshift" && component.props.type == "simple"
                InputMappingRowRedshiftEditor
                  value: mapping
                  tables: component.props.tables
                  onChange: (value) ->
                    component._handleChangeInputMapping(key, value)
                  onDelete: ->
                    component.props.onDeleteInputMapping(key)
                  disabled: component.props.disabled

              else if component.props.backend == "docker" && component.props.type == "r"
                InputMappingRowDockerEditor
                  value: mapping
                  tables: component.props.tables
                  onChange: (value) ->
                    component._handleChangeInputMapping(key, value)
                  onDelete: ->
                    component.props.onDeleteInputMapping(key)
                  disabled: component.props.disabled
        ).toArray()
