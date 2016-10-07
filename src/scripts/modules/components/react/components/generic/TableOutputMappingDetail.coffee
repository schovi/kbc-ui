React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TableSizeLabel = React.createFactory(require '../../../../transformations/react/components/TableSizeLabel')
TableBackendLabel = React.createFactory(require '../../../../transformations/react/components/TableBackendLabel')
TransformationTableTypeLabel = React.createFactory(
  require '../../../../transformations/react/components/TransformationTableTypeLabel'
)
FileSize = React.createFactory(require( '../../../../../react/common/FileSize').default)
Check = React.createFactory(require('kbc-react-components').Check)
ListGroup = React.createFactory(require('react-bootstrap').ListGroup)
ListGroupItem = React.createFactory(require('react-bootstrap').ListGroupItem)
_ = require('underscore')
TableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx').default)

{span, div, a, button, i, h4, small, em, ul, li, strong} = React.DOM
numeral = require 'numeral'
Immutable = require 'immutable'

TableInputMappingDetail = React.createClass(
  displayName: 'TableOutputMappingDetail'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    definition: React.PropTypes.object

  getDefaultProps: ->
    definition: Immutable.Map()

  render: ->
    ListGroupItems = [

      ListGroupItem {key: 'destination'},
        strong {className: "col-md-4"},
          'Destination table'
        span {className: "col-md-6"},
          if (@props.value.get('destination'))
            TableLinkEx
              tableId: @props.value.get('destination')
          else
            'Not set'

      ListGroupItem {key: 'incremental'},
        strong {className: "col-md-4"},
          'Incremental'
        span {className: "col-md-6"},
          Check
            isChecked: @props.value.get('incremental', false)

      ListGroupItem {key: 'primary_key'},
        strong {className: "col-md-4"},
          'Primary key'
        span {className: "col-md-6"},
          if @props.value.get('primary_key', Immutable.List()).count()
            @props.value.get('primary_key').join(', ')
          else
            'N/A'

      ListGroupItem {key: 'delete_where_column'},
        strong {className: "col-md-4"},
          'Delete rows'
        span {className: "col-md-6"},
          if @props.value.get('delete_where_column') && @props.value.get('delete_where_values')
            span {},
              'Where '
              strong {},
                @props.value.get('delete_where_column')
              ' '
              @props.value.get('delete_where_operator')
              ' '
              strong {},
                if @props.value.get('delete_where_values')
                  @props.value.get('delete_where_values').map((value) ->
                    if value == ''
                      return '[empty string]'
                    if value == ' '
                      return '[space character]'
                    return value
                  ).join(', ')
          else
            'N/A'

    ]
    ListGroup {className: "clearfix"}, _.reject(ListGroupItems, (obj) -> obj == undefined)
)

module.exports = TableInputMappingDetail
