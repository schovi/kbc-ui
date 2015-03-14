React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../components/TableBackendLabel')
TransformationTableTypeLabel = React.createFactory(require '../../components/TransformationTableTypeLabel')
FileSize = React.createFactory(require '../../../../../react/common/FileSize')
Check = React.createFactory(require '../../../../../react/common/Check')
{span, div, a, button, i, h4, small, em, ul, li, strong} = React.DOM
numeral = require 'numeral'

OutputMappingDetail = React.createClass(
  displayName: 'InputMappingDetail'
  mixins: [ImmutableRenderMixin]

  propTypes:
    transformationBackend: React.PropTypes.string.isRequired
    outputMapping: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired

  _isDestinationTableInRedshift: ->
    @props.tables.getIn([@props.outputMapping.get('destination'), 'bucket', 'backend']) == 'redshift'

  render: ->
    div className: 'table table-striped',
      span {className: 'tbody'},

        span {className: 'tr'},
          span {className: 'td'},
            'Destination table size'
          span {className: 'td'},
            FileSize
              size: @props.tables.getIn [@props.outputMapping.get('destination'), 'dataSizeBytes']

        span {className: 'tr'},
          span {className: 'td'},
            'Destination table rows'
          span {className: 'td'},
            if @props.tables.getIn [@props.outputMapping.get('destination'), 'rowsCount']
              numeral(@props.tables.getIn [@props.outputMapping.get('destination'), 'rowsCount']).format('0,0')
            else
              'N/A'

        span {className: 'tr'},
          span {className: 'td'},
            'Storage type'
          span {className: 'td'},
            @props.tables.getIn [@props.outputMapping.get('destination'), 'bucket', 'backend']

        span {className: 'tr'},
          span {className: 'td'},
            'Primary key'
          span {className: 'td'},
            if @props.outputMapping.get('primaryKey').count()
              @props.outputMapping.get('primaryKey').join(', ')
            else
              'N/A'

        span {className: 'tr'},
          span {className: 'td'},
            'Incremental'
          span {className: 'td'},
            Check
              isChecked: @props.outputMapping.get('incremental')

        span {className: 'tr'},
          span {className: 'td'},
            'Delete'
          span {className: 'td'},
            if @props.outputMapping.get('deleteWhereColumn')
              span {},
                'Where '
                strong {},
                  @props.outputMapping.get('deleteWhereColumn')
                ' '
                @props.outputMapping.get('deleteWhereOperator')
                ' '
                strong {},
                  @props.outputMapping.get('deleteWhereValues').join(', ')
            else
              'N/A'
)

module.exports = OutputMappingDetail
