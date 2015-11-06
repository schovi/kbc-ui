React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../components/TableBackendLabel')
{OverlayTrigger, Tooltip} = require 'react-bootstrap'
DeleteButton = require '../../../../../react/common/DeleteButton'
OutputMappingModal = require('../../modals/OutputMapping').default
actionCreators = require '../../../ActionCreators'

{span, div, a, button, i, h4, small, em, code} = React.DOM

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
    pendingActions: React.PropTypes.object.isRequired

  getInitialState: ->
    showModal: false

  openModal: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @setState
      showModal: true

  closeModal: ->
    @setState
      showModal: false

  render: ->
    span {className: 'table'},
      span {className: 'tbody'},
        span {className: 'tr'},
          span {className: 'td col-xs-4'},
            if @props.transformation.get('backend') == 'docker'
              'out/tables/' + @props.outputMapping.get 'source'
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
          span {className: 'td col-xs-1 col-xs-1 text-right kbc-no-wrap'},
            React.createElement DeleteButton,
              tooltip: 'Delete Output'
              isPending: @props.pendingActions.get('delete-output-' + @props.mappingIndex)
              confirm:
                title: 'Delete Output'
                text: span null,
                  "Do you really want to delete output mapping for "
                  code null,
                    @props.outputMapping.get('source')
                  "?"
                onConfirm: @_handleDelete
            React.createElement OverlayTrigger,
              overlay: React.createElement Tooltip, null, 'Edit Output'
              placement: 'top'
            ,
              React.DOM.button
                className: "btn btn-link"
                onClick: @openModal
              ,
                React.DOM.span null,
                  React.DOM.span {className: 'fa fa-fa kbc-icon-pencil'}
            React.createElement OutputMappingModal,
              mode: 'edit'
              tables: @props.tables
              buckets: @props.buckets
              backend: @props.transformation.get("backend")
              type: @props.transformation.get("type")
              mapping: @props.editingOutputMapping
              onChange: @_handleChange
              onCancel: @_handleCancel
              onSave: @_handleSave
              show: @state.showModal
              onHide: @closeModal

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
      'output'
      @props.editingId
      @props.mappingIndex
    )

  _handleDelete: ->
    actionCreators.deleteTransformationMapping(@props.bucket.get('id'),
      @props.transformation.get('id')
      'output'
      @props.mappingIndex
    )
)

module.exports = OutputMappingRow
