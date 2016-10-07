React = require 'react'
Link = React.createFactory(require('react-router').Link)
{ModalTrigger, OverlayTrigger, Tooltip} = require 'react-bootstrap'
DeleteButton = require '../../../../../react/common/DeleteButton'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../../../transformations/react/components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../../../transformations/react/components/TableBackendLabel')
TableOutputMappingModal = require('./TableOutputMappingModal').default
Immutable = require('immutable')

{span, div, a, button, i, h4, small, em, code} = React.DOM

module.exports = React.createClass(
  displayName: 'TableOutputMappingHeader'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    editingValue: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    buckets: React.PropTypes.object.isRequired
    mappingIndex: React.PropTypes.number.isRequired
    onChange: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired
    onCancel: React.PropTypes.func.isRequired
    onDelete: React.PropTypes.func.isRequired
    pendingActions: React.PropTypes.object.isRequired
    onEditStart: React.PropTypes.func.isRequired
    definition: React.PropTypes.object

  getDefaultProps: ->
    definition: Immutable.Map()

  render: ->
    component = @
    span {className: 'table'},
      span {className: 'tbody'},
        span {className: 'tr'},
          if (@props.definition.get('label'))
            [
              span {className: 'td col-xs-4', key: 'label'},
                @props.definition.get('label')
              span {className: 'td col-xs-1', key: 'arrow'},
                span {className: 'fa fa-chevron-right fa-fw'}
              span {className: 'td col-xs-6', key: 'destination'},
                TableSizeLabel
                  size: @props.tables.getIn [@props.value.get('destination'), 'dataSizeBytes']
                ' '
                TableBackendLabel
                  backend: @props.tables.getIn [@props.value.get('destination'), 'bucket', 'backend']
                if @props.value.get('destination') != ''
                  @props.value.get('destination')
                else
                  'Not set'
            ]
          else
            [
              span {className: 'td col-xs-4', key: 'source'},
                'out/tables/' + @props.value.get 'source'
              span {className: 'td col-xs-1', key: 'arrow'},
                span {className: 'fa fa-chevron-right fa-fw'}
              span {className: 'td col-xs-3', key: 'icons'},
                TableSizeLabel
                  size: @props.tables.getIn [@props.value.get('destination'), 'dataSizeBytes']
                ' '
                TableBackendLabel
                  backend: @props.tables.getIn [@props.value.get('destination'), 'bucket', 'backend']
              span {className: 'td col-xs-3', key: 'destination'},
                @props.value.get('destination')
            ]
          span {className: 'td col-xs-1 text-right kbc-no-wrap'},
            if (@props.value.get('destination') != '')
              React.createElement DeleteButton,
                tooltip: 'Delete Output'
                isPending: @props.pendingActions.getIn(['output', 'tables', @props.mappingIndex, 'delete'], false)
                confirm:
                  title: 'Delete Output'
                  text: span null,
                    "Do you really want to delete output mapping for "
                    code null,
                      @props.value.get('destination')
                    "?"
                  onConfirm: @props.onDelete
            React.createElement OverlayTrigger,
              overlay: React.createElement Tooltip, null, 'Edit Output'
              placement: 'top'
            ,
              React.createElement ModalTrigger,
                modal: React.createElement TableOutputMappingModal,
                  mode: 'edit'
                  tables: @props.tables
                  buckets: @props.buckets
                  mapping: @props.editingValue
                  onChange: @props.onChange
                  onCancel: @props.onCancel
                  onSave: @props.onSave
                  definition: @props.definition
              ,
                React.DOM.button
                  className: "btn btn-link"
                  onClick: (e) ->
                    component.props.onEditStart()
                    e.preventDefault()
                    e.stopPropagation()
                ,
                  React.DOM.span null,
                    React.DOM.span {className: 'fa fa-fw kbc-icon-pencil'}
)
