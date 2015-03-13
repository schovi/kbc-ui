React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
OrchestrationsStore = require '../../stores/OrchestrationsStore'
RoutesStore = require '../../../../stores/RoutesStore'
OrchestrationActiveButton = React.createFactory(require './OrchestrationActiveButton')
OrchestrationDeleteButton = React.createFactory(require './OrchestrationDeleteButton')
OrchestrationRunButton = React.createFactory(require './OrchestrationRunButton')

{button, span} = React.DOM

OrchestrationDetailButtons = React.createClass
  displayName: 'OrchestrationDetailButtons'
  mixins: [createStoreMixin(OrchestrationsStore)]

  _getOrchestrationId: ->
    RoutesStore.getCurrentRouteIntParam 'orchestrationId'

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    orchestration: OrchestrationsStore.get(@_getOrchestrationId())
    pendingActions: OrchestrationsStore.getPendingActionsForOrchestration(@_getOrchestrationId())

  render: ->
    React.DOM.span null,
      OrchestrationActiveButton
        orchestration: @state.orchestration
        isPending: @state.pendingActions.get 'active', false
      OrchestrationDeleteButton
        orchestration: @state.orchestration
        isPending: @state.pendingActions.get 'delete', false
      OrchestrationRunButton
        orchestration: @state.orchestration


module.exports = OrchestrationDetailButtons
