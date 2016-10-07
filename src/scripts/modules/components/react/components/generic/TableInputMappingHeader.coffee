React = require 'react'
Link = React.createFactory(require('react-router').Link)
{ModalTrigger, OverlayTrigger, Tooltip} = require 'react-bootstrap'
DeleteButton = require '../../../../../react/common/DeleteButton'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../../../transformations/react/components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../../../transformations/react/components/TableBackendLabel')
TableInputMappingModal = require('./TableInputMappingModal').default
Immutable = require('immutable')

{span, div, a, button, i, h4, small, em, code} = React.DOM

module.exports = React.createClass(
  displayName: 'TableInputMappingHeader'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    editingValue: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    mappingIndex: React.PropTypes.number.isRequired
    onChange: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired
    onCancel: React.PropTypes.func.isRequired
    onDelete: React.PropTypes.func.isRequired
    pendingActions: React.PropTypes.object.isRequired
    onEditStart: React.PropTypes.func.isRequired
    otherDestinations: React.PropTypes.object.isRequired
    definition: React.PropTypes.object

  getDefaultProps: ->
    definition: Immutable.Map()

  render: ->
    component = @
    span {className: 'table'},
      span {className: 'tbody'},
        span {className: 'tr'},
          if @props.definition.has('label')
            [
              span {className: 'td col-xs-4', key: 'label'},
                @props.definition.get('label')
              span {className: 'td col-xs-1', key: 'arrow'},
                span {className: 'fa fa-chevron-right fa-fw'}

              span {className: 'td col-xs-6', key: 'source'},
                TableSizeLabel {size: @props.tables.getIn [@props.value.get('source'), 'dataSizeBytes']}
                ' '
                TableBackendLabel {backend: @props.tables.getIn [@props.value.get('source'), 'bucket', 'backend']}
                if @props.value.get('source') != ''
                  @props.value.get('source')
                else
                  'Not set'
            ]
          else
            [
              span {className: 'td col-xs-3', key: 'icons'},
                TableSizeLabel {size: @props.tables.getIn [@props.value.get('source'), 'dataSizeBytes']}
                ' '
                TableBackendLabel {backend: @props.tables.getIn [@props.value.get('source'), 'bucket', 'backend']}
              span {className: 'td col-xs-4', key: 'source'},
                @props.value.get 'source'
              span {className: 'td col-xs-1', key: 'arrow'},
                span {className: 'fa fa-chevron-right fa-fw'}
              span {className: 'td col-xs-3', key: 'destination'},
                'in/tables/' + @props.value.get('destination', @props.value.get('source'))
            ]
          span {className: 'td col-xs-1 text-right kbc-no-wrap'},
            if (@props.value.get('source') != '')
              React.createElement DeleteButton,
                tooltip: 'Delete Input'
                isPending: @props.pendingActions.getIn(['input', 'tables', @props.mappingIndex, 'delete'], false)
                confirm:
                  title: 'Delete Input'
                  text: span null,
                    "Do you really want to delete input mapping for "
                    code null,
                      @props.value.get('source')
                    "?"
                  onConfirm: @props.onDelete
            React.createElement OverlayTrigger,
              overlay: React.createElement Tooltip, null, 'Edit Input'
              placement: 'top'
            ,
              React.createElement ModalTrigger,
                modal: React.createElement TableInputMappingModal,
                  mode: 'edit'
                  tables: @props.tables
                  mapping: @props.editingValue
                  onChange: @props.onChange
                  onCancel: @props.onCancel
                  onSave: @props.onSave
                  otherDestinations: @props.otherDestinations
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
