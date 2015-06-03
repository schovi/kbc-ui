React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../components/TableBackendLabel')

{span, div, a, button, i, h4, small, em} = React.DOM

OutputMappingRow = React.createClass(
  displayName: 'OutputMappingRow'
  mixins: [ImmutableRenderMixin]

  propTypes:
    outputMapping: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired

  render: ->
    span {className: 'table'},
      span {className: 'tbody'},
        span {className: 'tr'},
          span {className: 'td'},
            if @props.transformationBackend == 'docker'
              'in/tables/' + @props.outputMapping.get 'source'
            else
              @props.outputMapping.get 'source'
          span {className: 'td'},
            span {className: 'fa fa-chevron-right fa-fw'}
          span {className: 'td'},
            TableSizeLabel
              size: @props.tables.getIn [@props.outputMapping.get('destination'), 'dataSizeBytes']
            ' '
            TableBackendLabel
              backend: @props.tables.getIn [@props.outputMapping.get('destination'), 'bucket', 'backend']
          span {className: 'td'},
            @props.outputMapping.get 'destination'
)

module.exports = OutputMappingRow
