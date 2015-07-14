React = require 'react'
Link = React.createFactory(require('react-router').Link)
{ModalTrigger} = require 'react-bootstrap'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../components/TableBackendLabel')
TransformationTableTypeLabel = React.createFactory(require '../../components/TransformationTableTypeLabel')
InputMappingModal = require '../../modals/InputMapping'
actionCreators = require '../../../ActionCreators'

{span, div, a, button, i, h4, small, em} = React.DOM

module.exports = React.createClass(
  displayName: 'InputMappingRow'
  mixins: [ImmutableRenderMixin]

  propTypes:
    inputMapping: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    transformation: React.PropTypes.object.isRequired
    bucket: React.PropTypes.object.isRequired

  render: ->
    span {className: 'table'},
      span {className: 'tbody'},
        span {className: 'tr'},
          span {className: 'td col-xs-3'},
            TableSizeLabel {size: @props.tables.getIn [@props.inputMapping.get('source'), 'dataSizeBytes']}
            ' '
            TableBackendLabel {backend: @props.tables.getIn [@props.inputMapping.get('source'), 'bucket', 'backend']}
          span {className: 'td col-xs-4'},
            @props.inputMapping.get 'source'
          span {className: 'td col-xs-1'},
            span {className: 'fa fa-chevron-right fa-fw'}
          span {className: 'td col-xs-3'},
            TransformationTableTypeLabel {backend: @props.transformationBackend, type: @props.inputMapping.get('type')}
            ' '
            if @props.transformationBackend == 'docker'
              'in/tables/' + @props.inputMapping.get 'destination'
            else
              @props.inputMapping.get 'destination'
          span {className: 'td col-xs-1'},
            React.createElement ModalTrigger,
              modal: React.createElement InputMappingModal,
                mode: 'edit'
                tables: @props.tables
                backend: @props.transformation.get("backend")
                type: @props.transformation.get("type")
                mapping: @props.editingInputMapping
                onChange: @_handleChange
                onCancel: @_handleCancel
                onSave: @_handleSave
            ,
              React.DOM.button
                className: "btn btn-link pull-right"
                onClick: (e) ->
                  e.preventDefault()
                  e.stopPropagation()
              ,
                React.DOM.span null,
                  React.DOM.span {className: 'fa fa-edit'}
                  ' Edit'

  _handleChange: (newMapping) ->
    actionCreators.updateTransformationEditingField(@props.bucket.get('id'),
      @props.transformation.get('id')
      @props.editingId
      newMapping
    )

  _handleCancel: (newMapping) ->
    actionCreators.cancelTransformationEditingField(@props.bucket.get('id'),
      @props.transformation.get('id')
      @props.editingId
    )

  _handleSave: ->
    actionCreators.saveTransformationMapping(@props.bucket.get('id'),
      @props.transformation.get('id')
      'input'
      @props.editingId
      @props.mappingIndex
    )
)
