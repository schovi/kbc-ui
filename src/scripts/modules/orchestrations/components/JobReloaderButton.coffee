React = require 'react'

createStoreMixin = require '../../../react/mixins/createStoreMixin.coffee'

OrchestrationsActionCreators = require '../ActionCreators.coffee'
OrchestrationJobsStore = require '../stores/OrchestrationJobsStore.coffee'
RoutesStore = require '../../../stores/RoutesStore.coffee'
RefreshIcon = React.createFactory(require '../../../components/common/RefreshIcon.coffee')

JobReloaderButton = React.createClass
  displayName: 'JobReloaderButton'
  mixins: [createStoreMixin(OrchestrationJobsStore)]

  _getJobId: ->
    RoutesStore.getRouterState().getIn ['params', 'jobId']

  getStateFromStores: ->
    isLoading: OrchestrationJobsStore.isJobLoading(@_getJobId())

  _handleRefreshClick: ->
    OrchestrationsActionCreators.loadJobForce(@_getJobId())

  render: ->
    RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick


module.exports = JobReloaderButton