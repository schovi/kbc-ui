React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'

OrchestrationsActionCreators = require '../../ActionCreators.coffee'
OrchestrationsStore = require '../../stores/OrchestrationsStore.coffee'
RoutesStore = require '../../../../stores/RoutesStore.coffee'

RefreshIcon = React.createFactory(require '../../../../react/common/RefreshIcon.coffee')



OrchestrationReloaderButton = React.createClass
  displayName: 'OrchestrationsReloaderButton'
  mixins: [createStoreMixin(OrchestrationsStore)]

  _getOrchestrationId: ->
    RoutesStore.getRouterState().getIn ['params', 'orchestrationId']

  getStateFromStores: ->
    isLoading: OrchestrationsStore.getIsOrchestrationLoading(@_getOrchestrationId())

  _handleRefreshClick: ->
    OrchestrationsActionCreators.loadOrchestrationForce(@_getOrchestrationId())

  render: ->
    RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick


module.exports = OrchestrationReloaderButton