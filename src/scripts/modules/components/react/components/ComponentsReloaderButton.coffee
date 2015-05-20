React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'
{ActionTypes} = require '../../Constants'
PendingActionsStore = require '../../../../stores/PendingActionsStore'
RefreshIcon = React.createFactory(require('kbc-react-components').RefreshIcon)

module.exports = React.createClass
  displayName: 'ComponentsReloaderButton'
  mixins: [createStoreMixin(PendingActionsStore)]

  getStateFromStores: ->
    isLoading: PendingActionsStore.isPending(ActionTypes.INSTALLED_COMPONENTS_LOAD)

  _handleRefreshClick: ->
    InstalledComponentsActionCreators.loadComponentsForce()

  render: ->
    RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick
