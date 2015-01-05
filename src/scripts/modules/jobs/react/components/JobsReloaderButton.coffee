React = require('react')
createStoreMixin = require('../../../../react/mixins/createStoreMixin.coffee')
JobsStore = require('../../stores/JobsStore.coffee')
RefreshIcon = React.createFactory(require '../../../../react/common/RefreshIcon.coffee')
ActionCreators = require('../../ActionCreators.coffee')


JobsReloaderButton = React.createClass
  displayName: 'JobsReloaderButton'
  mixins: [createStoreMixin(JobsStore)]

  getStateFromStores: ->
    jobsLoading: JobsStore.getIsLoading()

  _handleRefreshClick: ->
    ActionCreators.reloadJobs()


  render: ->
    RefreshIcon isLoading: @state.jobsLoading, onClick: @_handleRefreshClick

module.exports = JobsReloaderButton
