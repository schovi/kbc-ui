React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../components/TableBackendLabel')
TransformationTableTypeLabel = React.createFactory(require '../../components/TransformationTableTypeLabel')
FileSize = React.createFactory(require '../../../../../react/common/FileSize')
Check = React.createFactory(require '../../../../../react/common/Check')
{span, div, a, button, i, h4, small, em, ul, li, strong} = React.DOM

InputMappingDetail = React.createClass(
  displayName: 'InputMappingDetail'
  mixins: [ImmutableRenderMixin]

  propTypes:
    transformationBackend: React.PropTypes.string.isRequired
    inputMapping: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired

  _isSourceTableInRedshift: ->
    @props.tables.getIn([@props.inputMapping.get('source'), 'bucket', 'backend']) == 'redshift'

  render: ->
    div className: 'table table-striped',
      span {className: 'tbody'},

        span {className: 'tr'},
          span {className: 'td'},
            'Source table size'
          span {className: 'td'},
            FileSize
              size: @props.tables.getIn [@props.inputMapping.get('source'), 'dataSizeBytes']

        span {className: 'tr'},
          span {className: 'td'},
            'Source table rows'
          span {className: 'td'},
            @props.tables.getIn [@props.inputMapping.get('source'), 'rowsCoount'], 'N/A'

        span {className: 'tr'},
          span {className: 'td'},
            'Storage type'
          span {className: 'td'},
            @props.tables.getIn [@props.inputMapping.get('source'), 'bucket', 'backend']

        if (@props.transformationBackend == 'db' || @props.transformationBackend == 'redshift')
          span {className: 'tr'},
            span {className: 'td'},
              'Optional'
            span {className: 'td'},
              Check
                isChecked: @props.inputMapping.get('optional')

        if @props.transformationBackend == 'redshift' && @_isSourceTableInRedshift()
          span {className: 'tr'},
            span {className: 'td'},
              'Type'
            span {className: 'td'},
              @props.inputMapping.get('type')

        if @props.transformationBackend == 'redshift' &&
            (@props.inputMapping.get('type') != 'view' || !@_isSourceTableInRedshift())
          span {className: 'tr'},
            span {className: 'td'},
              'Persistent'
            span {className: 'td'},
              Check
                isChecked: @props.inputMapping.get('persistent')

        span {className: 'tr'},
          span {className: 'td'},
            'Columns'
          span {className: 'td'},
            if @props.inputMapping.get('columns').count()
              @props.inputMapping.get('columns').join(', ')
            else
              'Use all columns'

        span {className: 'tr'},
          span {className: 'td'},
            'Filters'
          span {className: 'td'},
            if @props.inputMapping.get('whereColumn')
              span {},
                'Where '
                strong {},
                  @props.inputMapping.get('whereColumn')
                ' '
                @props.inputMapping.get('whereOperator')
                ' '
                strong {},
                  @props.inputMapping.get('whereValues').join(', ')
            if @props.inputMapping.get('days') != 0 && @props.inputMapping.get('whereColumn')
              ' and '
            if @props.inputMapping.get('days') != 0
              span {},
                if @props.inputMapping.get('whereColumn')
                  'changed in last '
                else
                  'Changed in last '
                @props.inputMapping.get('days')
                ' days'

            if @props.inputMapping.get('days') == 0 && !@props.inputMapping.get('whereColumn')
              'No filters set'

        if (@props.transformationBackend == 'db')
          span {className: 'tr'},
            span {className: 'td'},
              'Columns'
            span {className: 'td tags-list'},
              if @props.inputMapping.get('indexes').count()
                @props.inputMapping.get('indexes').map((index, key) ->
                  span {},
                    span {className: 'label label-default'},
                      index.toArray().join(', ')
                    ' '
                , @).toArray()
              else
                'No indexes set'

        if (@props.transformationBackend == 'db' || @props.inputMapping.get('type') == 'table')
          span {className: 'tr'},
            span {className: 'td'},
              'Data types'
            span {className: 'td'},
              if @props.inputMapping.get('datatypes').count()
                ul {},
                  @props.inputMapping.get('datatypes').map((definition, column) ->
                    li {},
                      strong {}, column
                      ' '
                      span {}, definition
                  , @).toArray()
              else
                'No data types set'

        if (@props.transformationBackend == 'redshift' && @props.inputMapping.get('type') == 'table')
          span {className: 'tr'},
            span {className: 'td'},
              'Sort key'
            span {className: 'td'},
              if @props.inputMapping.get('sortKey')
                @props.inputMapping.get('sortKey').split(',').join(', ')
              else
                'No sort key set'

        if (@props.transformationBackend == 'redshift' && @props.inputMapping.get('type') == 'table')
          span {className: 'tr'},
            span {className: 'td'},
              'Dist key'
            span {className: 'td'},
              if @props.inputMapping.get('distKey')
                @props.inputMapping.get('distKey').split(',').join(', ')
              else
                'No distribution key set'

        if (@props.transformationBackend == 'redshift' && !@_isSourceTableInRedshift())
          span {className: 'tr'},
            span {className: 'td'},
              'COPY options'
            span {className: 'td'},
              if @props.inputMapping.get('copyOptions')
                @props.inputMapping.get('copyOptions')
              else
                span {className: 'muted'},
                  "NULL AS 'NULL', ACCEPTANYDATE, TRUNCATECOLUMNS"
)

module.exports = InputMappingDetail
