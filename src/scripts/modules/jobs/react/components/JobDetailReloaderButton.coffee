React = require('react')
createStoreMixin = require('../../../../react/mixins/createStoreMixin.coffee')
JobsStore = require('../../stores/JobsStore.coffee')
RefreshIcon = React.createFactory(require '../../../../react/common/RefreshIcon.coffee')
ActionCreators = require('../../ActionCreators.coffee')
RoutesStore = require('../../../../stores/RoutesStore.coffee')
JobStatusLabel = React.createFactory(require '../../../../react/common/JobStatusLabel.coffee')

JobDetailReloaderButton = React.createClass
  displayName: 'JobDetailReloaderButton'
  mixins: [createStoreMixin(JobsStore)]

  _getJobId: ->
    RoutesStore.getRouterState().getIn ['params', 'jobId']

  getStateFromStores: ->
    job: JobsStore.get @_getJobId()
    jobLoading: JobsStore.getIsJobLoading(@_getJobId())

  render: ->
    React.DOM.span null,
      JobStatusLabel {status: @state.job.get 'status'}
      RefreshIcon {isLoading: true} if @state.jobLoading


module.exports = JobDetailReloaderButton
