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

  _renderAddButton: ->
    component = @
    React.DOM.button
      className: "btn btn-primary"
      onClick: (e) ->
        component.props.onAddInputMapping()
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
      React.DOM.h2 {}, 'Input Mapping'
      if @props.value.count()
        @props.value.map(
          (mapping, key) ->
            Panel
              className: 'kbc-panel-heading-with-table'
              key: key
              collapsible: true
              expanded: component.props.openInputMappings.get(key, false)
              eventKey: key
              onSelect: (event, key) ->
                component.props.toggleOpenInputMapping(key)
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
                          component.props.onDeleteInputMapping(key)
                          e.preventDefault()
                      ,
                        React.DOM.span className: 'kbc-icon-cup'

            ,
              if component.props.backend == "mysql" && component.props.type == "simple"
                InputMappingRowMySqlEditor
                  value: mapping
                  tables: component.props.tables
                  onChange: (value) ->
                    component._handleChangeInputMapping(key, value)
                  disabled: component.props.disabled
              else if component.props.backend == "redshift" && component.props.type == "simple"
                InputMappingRowRedshiftEditor
                  value: mapping
                  tables: component.props.tables
                  onChange: (value) ->
                    component._handleChangeInputMapping(key, value)
                  disabled: component.props.disabled

              else if component.props.backend == "docker" && component.props.type == "r"
                InputMappingRowDockerEditor
                  value: mapping
                  tables: component.props.tables
                  onChange: (value) ->
                    component._handleChangeInputMapping(key, value)
                  disabled: component.props.disabled
        ).toArray()
      if @props.value.count()
        React.DOM.div className: 'text-right',
          @_renderAddButton()

