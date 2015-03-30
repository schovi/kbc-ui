React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require('immutable')

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

CodeMirror = React.createFactory(require 'react-code-mirror')
{Panel, Accordion, PanelGroup, Input} = require('react-bootstrap')
Panel  = React.createFactory Panel
Accordion = React.createFactory Accordion
PanelGroup = React.createFactory PanelGroup
Input = React.createFactory Input
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'
TransformationTypeLabel = React.createFactory(require '../../components/TransformationTypeLabel')
Select = React.createFactory(require('react-select'))
_ = require('underscore')
SelectRequires = React.createFactory(require('./SelectRequires'))
QueryEditorContainer = React.createFactory(require('./QueryEditorContainer'))

require('codemirror/mode/sql/sql')
require('codemirror/mode/r/r')

{div, span, input, strong, form, button, h4, i, ul, li, button, a, small, p, code, em, textarea, label} = React.DOM

TransformationDetailEdit = React.createClass
  displayName: 'TransformationDetailEdit'

  mixins: [ImmutableRenderMixin]

  propTypes:
    transformation: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    transformations: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    isSaving: React.PropTypes.bool.isRequired

  _handleChangeProperty: (property, value) ->
    if !Array.isArray(property)
      property = [property]
    transformation = @props.transformation.setIn(property, value)
    if property[0] == 'phase'
      transformation = transformation.setIn(["requires"], Immutable.List())
    @props.onChange(transformation)

  render: ->
    props = @props
    component = @
    div {},
      form className: 'form-horizontal',
        div className: "row col-md-12",
          h4 {}, 'General'
        div className: "row",
          div className: "col-md-6",
            Input
              type: 'static'
              label: 'Id'
              value: @props.transformation.get 'id'
              labelClassName: 'col-xs-4'
              wrapperClassName: 'col-xs-8'
          div className: "col-md-6",
            Input
              type: 'static'
              label: 'Type'
              value: TransformationTypeLabel
                backend: @props.transformation.get 'backend'
                type: @props.transformation.get 'type'
              labelClassName: 'col-xs-4'
              wrapperClassName: 'col-xs-8'
        div className: "row",
          div className: "col-md-6",
            Input
              type: 'text'
              label: 'Name'
              value: @props.transformation.get 'name'
              labelClassName: 'col-xs-4'
              wrapperClassName: 'col-xs-8'
              onChange: (e) -> component._handleChangeProperty("name", e.target.value)
              disabled: @props.isSaving
          div className: "col-md-6",
            Input
              type: 'number'
              label: 'Phase'
              value: @props.transformation.get("phase")
              disabled: @props.isSaving
              onChange: (e) -> component._handleChangeProperty("phase", parseInt(e.target.value))
              placeholder: '1'
              labelClassName: 'col-xs-4'
              wrapperClassName: 'col-xs-8'
        div className: "row col-md-12",
          Input
            type: 'textarea'
            label: 'Description'
            value: @props.transformation.get("description")
            disabled: @props.isSaving
            placeholder: "Describe the transformation"
            onChange: (e) -> component._handleChangeProperty("description", e.target.value)
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-10'
        div className: "row col-md-12",
          h4 {}, 'Dependencies'
        div className: "row col-md-12",
          div className: 'form-group',
            label className: 'col-xs-2 control-label', 'Requires'
            div className: 'col-xs-10',
              SelectRequires
                name: 'requires'
                value: @props.transformation.get("requires")
                transformations: @props.transformations
                transformation: @props.transformation
                phase: @props.transformation.get("phase")
                onChange: (value) ->
                  component._handleChangeProperty("requires", value)
                disabled: @props.isSaving
              span {className: "help-block"},
                "Transformations that will be executed before this transformation"
        div className: "row col-md-12",
          h4 {}, if @props.transformation.get("backend") == 'docker' then "Script" else "Queries"
          div className: 'form-group',
            div className: 'col-xs-12',
              QueryEditorContainer
                transformation: @props.transformation
                value: @props.transformation.get("queries", "")
                disabled: @props.isSaving
                onChange: (value) ->
                  component._handleChangeProperty("queries", value)



module.exports = TransformationDetailEdit
