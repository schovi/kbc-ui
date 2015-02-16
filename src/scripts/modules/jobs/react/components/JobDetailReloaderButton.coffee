React = require('react')
createStoreMixin = require('../../../../react/mixins/createStoreMixin')
JobsStore = require('../../stores/JobsStore')
RefreshIcon = React.createFactory(require '../../../../react/common/RefreshIcon')
ActionCreators = require('../../ActionCreators')
RoutesStore = require('../../../../stores/RoutesStore')
JobStatusLabel = React.createFactory(require '../../../../react/common/JobStatusLabel')

JobDetailReloaderButton = React.createClass
  displayName: 'JobDetailReloaderButton'
  mixins: [createStoreMixin(JobsStore)]

  _getJobId: ->
    RoutesStore.getCurrentRouteIntParam 'jobId'

  getStateFromStores: ->
    job: JobsStore.get @_getJobId()
    jobLoading: JobsStore.getIsJobLoading(@_getJobId())

  render: ->
    React.DOM.span null,
      JobStatusLabel {status: @state.job.get 'status'}
      RefreshIcon {isLoading: true} if @state.jobLoading


module.exports = JobDetailReloaderButton
