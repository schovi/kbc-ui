React = require 'react'
createStoreMixin = require '../../../react/mixins/createStoreMixin.coffee'
OrchestrationsStore = require '../stores/OrchestrationsStore.coffee'
RoutesStore = require '../../../stores/RoutesStore.coffee'
OrchestrationActiveButton = React.createFactory(require './OrchestrationActiveButton.coffee')
OrchestrationDeleteButton = React.createFactory(require './OrchestrationDeleteButton.coffee')
OrchestrationRunButton = React.createFactory(require './OrchestrationRunButton.coffee')

{button, span} = React.DOM

OrchestrationDetailButtons = React.createClass
  displayName: 'OrchestrationDetailButtons'
  mixins: [createStoreMixin(OrchestrationsStore)]

  _getOrchestrationId: ->
    RoutesStore.getRouterState().getIn ['params', 'orchestrationId']

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    orchestration: OrchestrationsStore.get(@_getOrchestrationId())

  render: ->
    console.log 'render buttons'
    React.DOM.span null,
      OrchestrationActiveButton(orchestration: @state.orchestration),
      OrchestrationDeleteButton(orchestration: @state.orchestration),
      OrchestrationRunButton(orchestration: @state.orchestration)


module.exports = OrchestrationDetailButtons
