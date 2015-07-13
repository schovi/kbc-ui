React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../components/TableBackendLabel')
{ModalTrigger} = require 'react-bootstrap'
OutputMappingModal = require '../../modals/OutputMapping'
actionCreators = require '../../../ActionCreators'

{span, div, a, button, i, h4, small, em} = React.DOM

OutputMappingRow = React.createClass(
  displayName: 'OutputMappingRow'
  mixins: [ImmutableRenderMixin]

  propTypes:
    outputMapping: React.PropTypes.object.isRequired
    mappingIndex: React.PropTypes.number.isRequired
    editingOutputMapping: React.PropTypes.object.isRequired
    editingId: React.PropTypes.string.isRequired
    transformation: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    buckets: React.PropTypes.object.isRequired
    bucket: React.PropTypes.object.isRequired

  render: ->
    span {className: 'table'},
      span {className: 'tbody'},
        span {className: 'tr'},
          span {className: 'td col-xs-4'},
            if @props.transformation.get('backend') == 'docker'
              'in/tables/' + @props.outputMapping.get 'source'
            else
              @props.outputMapping.get 'source'
          span {className: 'td col-xs-1'},
            span {className: 'fa fa-chevron-right fa-fw'}
          span {className: 'td col-xs-3'},
            TableSizeLabel
              size: @props.tables.getIn [@props.outputMapping.get('destination'), 'dataSizeBytes']
            ' '
            TableBackendLabel
              backend: @props.tables.getIn [@props.outputMapping.get('destination'), 'bucket', 'backend']
          span {className: 'td col-xs-3'},
            @props.outputMapping.get 'destination'
          span {className: 'td col-xs-1'},
            React.createElement ModalTrigger,
              modal: React.createElement OutputMappingModal,
                mode: 'edit'
                tables: @props.tables
                buckets: @props.buckets
                backend: @props.transformation.get("backend")
                type: @props.transformation.get("type")
                mapping: @props.editingOutputMapping
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
    actionCreators.saveTransformationOutputMapping(@props.bucket.get('id'),
      @props.transformation.get('id')
      @props.editingId
      @props.mappingIndex
    )
)

module.exports = OutputMappingRow
