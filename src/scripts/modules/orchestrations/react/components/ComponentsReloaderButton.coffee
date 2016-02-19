React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
InstalledComponentsActionCreators = require '../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../components/stores/InstalledComponentsStore'
OrchestrationStore = require '../../stores/OrchestrationsStore'
OrchestrationActionCreators = require '../../ActionCreators'

RefreshIcon = React.createFactory(require('kbc-react-components').RefreshIcon)

module.exports = React.createClass
  displayName: 'ComponentsReloaderButton'
  mixins: [createStoreMixin(InstalledComponentsStore)]

  getStateFromStores: ->
    isLoading: InstalledComponentsStore.getIsLoading()

  _handleRefreshClick: ->
    InstalledComponentsActionCreators.loadComponentsForce()
    OrchestrationActionCreators.loadOrchestrationsForce()

  render: ->
    RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick
