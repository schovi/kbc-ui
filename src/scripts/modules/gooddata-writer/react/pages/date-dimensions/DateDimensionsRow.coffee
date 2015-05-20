React = require 'react'
pureRenderMixin = require('../../../../../react/mixins/ImmutableRendererMixin')

{tr, td} = React.DOM
{Check} = require 'kbc-react-components'

DeleteButton = require '../../../../../react/common/DeleteButton'

actionCreators = require '../../../actionCreators'


module.exports = React.createClass
  displayName: 'DateDimensionsRow'
  mixins: [pureRenderMixin]
  propTypes:
    dimension: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired

  _handleDelete: ->
    actionCreators.deleteDateDimension(@props.configurationId, @props.dimension.get 'id')

  render: ->
    console.log 'render row', @props.dimension.get('id')
    tr null,
      td null,
        @props.dimension.getIn ['data', 'name']
      td null,
        React.createElement Check,
          isChecked: @props.dimension.getIn ['data', 'includeTime']
      td className: 'text-right',
        React.createElement DeleteButton,
          tooltip: 'Delete date dimension'
          isPending: @props.dimension.get('pendingActions').contains 'delete'
          confirm:
            title: 'Delete?'
            text: 'Delete'
            onConfirm: @_handleDelete


