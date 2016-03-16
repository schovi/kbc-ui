React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../../../transformations/react/components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../../../transformations/react/components/TableBackendLabel')
TransformationTableTypeLabel = React.createFactory(
  require '../../../../transformations/react/components/TransformationTableTypeLabel'
)
FileSize = React.createFactory(require('../../../../../react/common/FileSize').default)
Check = React.createFactory(require('kbc-react-components').Check)
ListGroup = React.createFactory(require('react-bootstrap').ListGroup)
ListGroupItem = React.createFactory(require('react-bootstrap').ListGroupItem)
_ = require('underscore')
TableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx').default)

{span, div, a, button, i, h4, small, em, ul, li, strong} = React.DOM
numeral = require 'numeral'
Immutable = require 'immutable'

TableInputMappingDetail = React.createClass(
  displayName: 'TableInputMappingDetail'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired

  render: ->
    ListGroupItems = [

      ListGroupItem {key: 'source'},
        strong {className: "col-md-4"},
          'Source table'
        span {className: "col-md-6"},
          TableLinkEx
            tableId: @props.value.get('source')

      ListGroupItem {key: 'columns'},
        strong {className: "col-md-4"},
          'Columns'
        span {className: "col-md-6"},
          if @props.value.get('columns', Immutable.List()).count()
            @props.value.get('columns').join(', ')
          else
            'Use all columns'

      ListGroupItem {key: 'where_column'},
        strong {className: "col-md-4"},
          'Filters'
        span {className: "col-md-6"},
          if @props.value.get('where_column')
            span {},
              'Where '
              strong {},
                @props.value.get('where_column')
              ' '
              @props.value.get('where_operator')
              ' '
              strong {},
                @props.value.get('where_values', Immutable.List()).map((value) ->
                  if value == ''
                    return '[empty string]'
                  if value == ' '
                    return '[space character]'
                  return value
                ).join(', ')
          if @props.value.get('days', 0) != 0 && @props.value.get('where_column')
            ' and '
          if @props.value.get('days', 0) != 0
            span {},
              if @props.value.get('where_column')
                'changed in last '
              else
                'Changed in last '
              @props.value.get('days', 0)
              ' days'
          if @props.value.get('days', 0) == 0 && !@props.value.get('where_column')
            'N/A'

    ]
    ListGroup {className: "clearfix"}, _.reject(ListGroupItems, (obj) -> obj == undefined)
)

module.exports = TableInputMappingDetail
