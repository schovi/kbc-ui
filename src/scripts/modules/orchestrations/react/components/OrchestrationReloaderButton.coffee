React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'

OrchestrationsActionCreators = require '../../ActionCreators'
OrchestrationsStore = require '../../stores/OrchestrationsStore'
RoutesStore = require '../../../../stores/RoutesStore'

RefreshIcon = React.createFactory(require '../../../../react/common/RefreshIcon')



OrchestrationReloaderButton = React.createClass
  displayName: 'OrchestrationsReloaderButton'
  mixins: [createStoreMixin(OrchestrationsStore)]

  _getOrchestrationId: ->
    RoutesStore.getCurrentRouteIntParam 'orchestrationId'

  getStateFromStores: ->
    isLoading: OrchestrationsStore.getIsOrchestrationLoading(@_getOrchestrationId())

  _handleRefreshClick: ->
    OrchestrationsActionCreators.loadOrchestrationForce(@_getOrchestrationId())

  render: ->
    RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick


module.exports = OrchestrationReloaderButton