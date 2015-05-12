React = require('react')
createStoreMixin = require('../../../../react/mixins/createStoreMixin')
JobsStore = require('../../stores/JobsStore')
Loader = React.createFactory(require '../../../../react/common/Loader')
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
      if @state.jobLoading
        React.DOM.span null,
          ' '
          Loader()


module.exports = JobDetailReloaderButton
