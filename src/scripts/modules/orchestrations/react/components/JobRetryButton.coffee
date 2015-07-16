React = require 'react'
createStoreMixin = require('../../../../react/mixins/createStoreMixin')
JobsStore = require('../../stores/OrchestrationJobsStore')
ActionCreators = require('../../ActionCreators')
RoutesStore = require('../../../../stores/RoutesStore')
Confirm = React.createFactory(require '../../../../react/common/Confirm')

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'JobRetryButton'
  mixins: [createStoreMixin(JobsStore)]
  propTypes:
    job: React.PropTypes.object.isRequired
    notify: React.PropTypes.bool

  getDefaultProps: ->
    tooltipPlacement: 'top'

  _getJobId: ->
    RoutesStore.getCurrentRouteIntParam 'jobId'

  getStateFromStores: ->
    jobId = @_getJobId()
    job: JobsStore.getJob jobId

  _handleRetry: ->
    ActionCreators.retryOrchestrationJob(
      @state.job.get('id')
      @state.job.get('tasks').toJS()
      @state.job.get('orchestrationId')
      @props.notify
    )

  _canBeRetried: ->
    status = @state.job.get('status')
    status is 'success' ||
      status is 'error' ||
      status is 'cancelled' ||
      status is 'canceled' ||
      status is 'terminated' ||
        status is 'warning' ||
          status is 'warn'

  render: ->
    if @_canBeRetried()
      Confirm
        title: 'Retry job'
        text: "You are about to run orchestration again"
        buttonLabel: 'Run'
        onConfirm: @_handleRetry
      ,
        button
          className: 'btn btn-link'
        ,
          span
            className: 'fa fa-fw fa-play'
          ' Job retry'
    else
      null