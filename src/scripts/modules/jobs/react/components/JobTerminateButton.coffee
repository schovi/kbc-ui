React = require 'react'
createStoreMixin = require('../../../../react/mixins/createStoreMixin')
JobsStore = require('../../stores/JobsStore')
ActionCreators = require('../../ActionCreators')
RoutesStore = require('../../../../stores/RoutesStore')
Confirm = require '../../../../react/common/Confirm'
Loader = require '../../../../react/common/Loader'


{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'JobTerminateButton'
  mixins: [createStoreMixin(JobsStore)]

  _getJobId: ->
    RoutesStore.getCurrentRouteIntParam 'jobId'

  getStateFromStores: ->
    jobId = @_getJobId()
    job: JobsStore.get jobId
    isTerminating: JobsStore.getIsJobTerminating jobId

  _handleTerminate: ->
    ActionCreators.terminateJob @state.job.get 'id'

  render: ->
    if @state.job.get('status') == 'waiting' || @state.job.get('status') == 'processing'
      React.DOM.div null,
        React.createElement(Loader) if @state.isTerminating
        ' '
        React.createElement Confirm,
          title: 'Terminate Job'
          text: "Do you really want to terminate the job #{@state.job.get('id')}?"
          buttonLabel: 'Terminate'
          onConfirm: @_handleTerminate
        ,
          button
            className: 'btn btn-default'
            disabled: @state.isTerminating
          ,
            span className: 'fa fa-fw fa-times'
            'Terminate'
    else
      null
