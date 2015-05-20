React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'

OrchestrationsActionCreators = require '../../ActionCreators'
OrchestrationsStore = require '../../stores/OrchestrationsStore'
RefreshIcon = React.createFactory(require('kbc-react-components').RefreshIcon)

OrchestrationsReloaderButton = React.createClass
  displayName: 'OrchestrationsReloaderButton'
  mixins: [createStoreMixin(OrchestrationsStore)]

  getStateFromStores: ->
    isLoading: OrchestrationsStore.getIsLoading()

  _handleRefreshClick: (e) ->
    OrchestrationsActionCreators.loadOrchestrationsForce()

  render: ->
    RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick


module.exports = OrchestrationsReloaderButton