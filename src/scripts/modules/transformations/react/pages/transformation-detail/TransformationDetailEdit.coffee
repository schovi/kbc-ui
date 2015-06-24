React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require('immutable')

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

CodeMirror = React.createFactory(require 'react-code-mirror')
{Input, FormControls} = require('react-bootstrap')
Input = React.createFactory Input
StaticText = React.createFactory FormControls.Static
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'
TransformationTypeLabel = React.createFactory(require '../../components/TransformationTypeLabel')
Select = React.createFactory(require('react-select'))
_ = require('underscore')
SelectRequires = React.createFactory(require('./SelectRequires'))
QueryEditorContainer = React.createFactory(require('./QueryEditorContainer'))
PackagesEditorContainer = React.createFactory(require('./PackagesEditorContainer'))
InputMappingEditorContainer = React.createFactory(require('./InputMappingEditorContainer'))
OutputMappingEditorContainer = React.createFactory(require('./OutputMappingEditorContainer'))
Textarea = require 'react-textarea-autosize'

require('codemirror/mode/sql/sql')
require('codemirror/mode/r/r')

{div, span, input, strong, form, button, h4, h2, i, ul, li, button, a, small, p, code, em, textarea, label} = React.DOM

TransformationDetailEdit = React.createClass
  displayName: 'TransformationDetailEdit'

  mixins: [ImmutableRenderMixin]

  propTypes:
    transformation: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    buckets: React.PropTypes.object.isRequired
    transformations: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    isSaving: React.PropTypes.bool.isRequired
    openInputMappings: React.PropTypes.object.isRequired
    toggleOpenInputMapping: React.PropTypes.func.isRequired
    onAddInputMapping: React.PropTypes.func.isRequired
    onDeleteInputMapping: React.PropTypes.func.isRequired
    openOutputMappings: React.PropTypes.object.isRequired
    toggleOpenOutputMapping: React.PropTypes.func.isRequired
    onAddOutputMapping: React.PropTypes.func.isRequired
    onDeleteOutputMapping: React.PropTypes.func.isRequired

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
    div className: 'form-horizontal',
      div className: 'kbc-row',
        h2 {}, 'General'
        div className: "row",
          div className: "col-md-6",
            StaticText
              key: 'id'
              label: 'Id'
              labelClassName: 'col-xs-4'
              wrapperClassName: 'col-xs-8'
              value: @props.transformation.get 'id'
          div className: "col-md-6",
            # mock StaticText, as it cannot contain a component
            div className: "form-group",
              label className: "control-label col-xs-4",
                span {},
                  "Type"
              div className: "col-xs-8",
                p
                  label: "Backend"
                  className: "form-control-static"
                ,
                  TransformationTypeLabel
                    backend: @props.transformation.get 'backend'
                    type: @props.transformation.get 'type'

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
        div className: "row",
          div className: "col-md-12",
            div className: "form-group",
              label {className: "control-label col-xs-2", style: {width: '16%'}},
                'Description'
              div {className: 'col-xs-10', style: {width: '84%'}},
                React.createElement Textarea,
                  value: @props.transformation.get("description")
                  disabled: @props.isSaving
                  placeholder: "Describe the transformation"
                  className: "form-control"
                  onChange: (e) -> component._handleChangeProperty("description", e.target.value)
      div className: "kbc-row",
        h2 {}, 'Dependencies'
        div className: "row",
          div className: "col-md-12",
            div className: 'form-group',
              label {className: 'col-xs-2 control-label', style: {width: '16%'}}, 'Requires'
              div {className: 'col-xs-10', style: {width: '84%'}},
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
      div className: "kbc-row",
        InputMappingEditorContainer
          value: @props.transformation.get("input")
          tables: @props.tables
          backend: @props.transformation.get("backend")
          type: @props.transformation.get("type")
          disabled: @props.isSaving
          onChange: (value) ->
            component._handleChangeProperty("input", value)
          onAddInputMapping: @props.onAddInputMapping
          onDeleteInputMapping: @props.onDeleteInputMapping
          openInputMappings: @props.openInputMappings
          toggleOpenInputMapping: @props.toggleOpenInputMapping

      div className: "kbc-row",
        OutputMappingEditorContainer
          value: @props.transformation.get("output")
          tables: @props.tables
          buckets: @props.buckets
          backend: @props.transformation.get("backend")
          type: @props.transformation.get("type")
          disabled: @props.isSaving
          onChange: (value) ->
            component._handleChangeProperty("output", value)
          onAddOutputMapping: @props.onAddOutputMapping
          onDeleteOutputMapping: @props.onDeleteOutputMapping
          openOutputMappings: @props.openOutputMappings
          toggleOpenOutputMapping: @props.toggleOpenOutputMapping

      if @props.transformation.get("backend") == 'docker' && @props.transformation.get("type") == "r"
        div className: "kbc-row",
          h2 {}, "Packages"
          PackagesEditorContainer
            name: "packages"
            value: @props.transformation.get("packages")
            input: @props.transformation.get("packagesInput", "")
            disabled: @props.isSaving
            onChangeValue: (value) ->
              component._handleChangeProperty("packages", value)
            onChangeInput: (value) ->
              component._handleChangeProperty("packagesInput", value)
      div className: "kbc-row",
        h2 {}, if @props.transformation.get("backend") == 'docker' then "Script" else "Queries"
        div className: 'form-group',
          div className: 'col-xs-12',
            QueryEditorContainer
              transformation: @props.transformation
              value: @props.transformation.get("queries", "")
              disabled: @props.isSaving
              onChange: (value) ->
                component._handleChangeProperty("queries", value)




module.exports = TransformationDetailEdit
