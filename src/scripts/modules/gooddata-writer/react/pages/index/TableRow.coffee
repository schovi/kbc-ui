React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
Link = React.createFactory(require('react-router').Link)

ActivateDeactivateButton = React.createFactory(require '../../../../../react/common/ActivateDeactivateButton')

actionCreators = require '../../../actionCreators'

{span, div, a, button, i} = React.DOM

module.exports = React.createClass
  displayName: 'TableRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    table: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired

  render: ->
    Link
      className: 'tr'
      to: 'gooddata-writer-table'
      params:
        config: @props.configId
        table: @props.table.get 'id'
    ,
      span className: 'td',
        @props.table.get 'id'
      span className: 'td',
        @props.table.getIn 'data', 'name'
      span className: 'td text-right',
        ActivateDeactivateButton
          activateTooltip: 'Enable Export'
          deactivateTooltip: 'Disable Export'
          isActive: @props.table.getIn ['data', 'export']
          isPending: @props.table.get('pendingActions').contains 'exportStatusChange'
          onChange: @_handleExportChange

  _handleExportChange: (newExportStatus) ->
    actionCreators.changeTableExportStatus(@props.configId, @props.table.get('id'), newExportStatus)
