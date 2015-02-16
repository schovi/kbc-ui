React = require 'react'
OrchestrationsNavRow = require './OrchestrationsNavRow'

ImmutableRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

{div} = React.DOM

OrchestrationsNav = React.createClass
  displayName: 'OrchestrationsNavList'
  mixins: [ImmutableRendererMixin]

  propTypes:
    orchestrations: React.PropTypes.object.isRequired
    activeOrchestrationId: React.PropTypes.number.isRequired

  render: ->
    filtered = @props.orchestrations
    if filtered.size
      childs = filtered.map((orchestration) ->
        OrchestrationsNavRow
          orchestration: orchestration
          key: orchestration.get('id')
          isActive: @props.activeOrchestrationId == orchestration.get('id')
      , @).toArray()
    else
      childs = div className: 'list-group-item',
        'No Orchestrations found'

    div className: 'list-group kb-orchestrations-nav',
      childs


module.exports = OrchestrationsNav