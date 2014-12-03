React = require 'react'

InstalledComponentsActionCreators = require '../InstalledComponentsActionCreators.coffee'
InstalledComponetsStore = require '../stores/InstalledComponentsStore.coffee'
RefreshIcon = React.createFactory(require '../../../components/common/RefreshIcon.coffee')

getStateFromStores = ->
  isLoading: InstalledComponetsStore.getIsLoading()

ComponentsReloaderButton = React.createClass
  displayName: 'ComponentsReloaderButton'

  getInitialState: ->
    getStateFromStores()

  componentDidMount: ->
    InstalledComponetsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    InstalledComponetsStore.removeChangeListener(@_onChange)

  _handleRefreshClick: (e) ->
    InstalledComponentsActionCreators.loadComponentsForce()

  _onChange: ->
    @setState(getStateFromStores())

  render: ->
    RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick


module.exports = ComponentsReloaderButton