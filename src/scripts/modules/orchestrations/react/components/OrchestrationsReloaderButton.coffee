React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'

OrchestrationsActionCreators = require '../../ActionCreators.coffee'
OrchestrationsStore = require '../../stores/OrchestrationsStore.coffee'
RefreshIcon = React.createFactory(require '../../../../react/common/RefreshIcon.coffee')

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