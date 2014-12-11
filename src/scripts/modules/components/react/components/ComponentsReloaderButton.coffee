React = require 'react'


createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators.coffee'
InstalledComponetsStore = require '../../stores/InstalledComponentsStore.coffee'
RefreshIcon = React.createFactory(require '../../../../react/common/RefreshIcon.coffee')

ComponentsReloaderButton = React.createClass
  displayName: 'ComponentsReloaderButton'
  mixins: [createStoreMixin(InstalledComponetsStore)]

  getStateFromStores: ->
    isLoading: InstalledComponetsStore.getIsLoading()

  _handleRefreshClick: ->
    InstalledComponentsActionCreators.loadComponentsForce()

  render: ->
    RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick


module.exports = ComponentsReloaderButton