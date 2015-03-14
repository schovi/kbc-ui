React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../components/TableBackendLabel')
TransformationTableTypeLabel = React.createFactory(require '../../components/TransformationTableTypeLabel')

{span, div, a, button, i, h4, small, em} = React.DOM

InputMappingRow = React.createClass(
  displayName: 'InputMappingRow'
  mixins: [ImmutableRenderMixin]

  propTypes:
    transformationBackend: React.PropTypes.string.isRequired
    inputMapping: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired

  render: ->
    span {className: 'table'},
      span {className: 'tbody'},
        span {className: 'tr'},
          span {className: 'td'},
            TableSizeLabel {size: @props.tables.getIn [@props.inputMapping.get('source'), 'dataSizeBytes']}
            ' '
            TableBackendLabel {backend: @props.tables.getIn [@props.inputMapping.get('source'), 'bucket', 'backend']}
          span {className: 'td'},
            @props.inputMapping.get 'source'
          span {className: 'td'},
            span {className: 'fa fa-chevron-right fa-fw'}
            ' '
            TransformationTableTypeLabel {backend: @props.transformationBackend, type: @props.inputMapping.get('type')}
            ' '
            if @props.transformationBackend == 'docker'
              'in/tables/' + @props.inputMapping.get 'destination'
            else
              @props.inputMapping.get 'destination'
)

module.exports = InputMappingRow
