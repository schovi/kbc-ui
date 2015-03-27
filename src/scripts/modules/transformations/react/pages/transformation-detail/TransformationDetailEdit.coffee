React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require('immutable')

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TransformationsActionCreators = require '../../../ActionCreators'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')

InputMappingRow = React.createFactory(require './InputMappingRow')
InputMappingDetail = React.createFactory(require './InputMappingDetail')
OutputMappingRow = React.createFactory(require './OutputMappingRow')
OutputMappingDetail = React.createFactory(require './OutputMappingDetail')
CodeMirror = React.createFactory(require 'react-code-mirror')
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
ActivateDeactivateButton = React.createFactory(require '../../../../../react/common/ActivateDeactivateButton')
GraphContainer = require './GraphContainer'
{Panel, Accordion, PanelGroup} = require('react-bootstrap')
Panel  = React.createFactory Panel
Accordion = React.createFactory Accordion
PanelGroup = React.createFactory Accordion
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'
TransformationTypeLabel = React.createFactory(require '../../components/TransformationTypeLabel')
ConfigureTransformationSandbox = require '../../components/ConfigureTransformationSandbox'
SqlDepModalTrigger = require '../../modals/SqlDepModalTrigger.coffee'

require('codemirror/mode/sql/sql')
require('codemirror/mode/r/r')

{div, span, input, strong, form, button, h4, i, ul, li, button, a, small, p, code, em, textarea} = React.DOM

TransformationDetailEdit = React.createClass
  displayName: 'TransformationDetailEdit'

  mixins: [ImmutableRenderMixin]

  propTypes:
    transformation: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    isSaving: React.PropTypes.bool.isRequired

  _handleChangeDescription: (e) ->
    @props.onChange(@props.transformation.set("description", e.target.value))

  render: ->
    props = @props
    component = @
    div {},
      h4 {}, 'Description'
      div className: 'form-horizontal',
        div className: 'form-group',
          textarea
            ref: 'textArea'
            value: @props.transformation.get("description")
            disabled: @props.isSaving
            placeholder: "Describe the transformation"
            className: 'form-control'
            onChange: @_handleChangeDescription

module.exports = TransformationDetailEdit
