React = require('react')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
JobsStore = require('../../../stores/JobsStore')
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
Events = React.createFactory(require '../../../../sapi-events/react/Events')
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName')
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))
Duration = React.createFactory(require('../../../../../react/common/Duration'))
date = require '../../../../../utils/date'
Tree = require '../../../../../react/common/Tree'
{strong,div, h2, span, h4, section, p} = React.DOM

JobDetail = React.createClass
  mixins: [createStoreMixin(JobsStore)]

  getStateFromStores: ->
    job: JobsStore.get RoutesStore.getCurrentRouteIntParam('jobId')

  _renderRunInfoRow: (job) ->
    jobStarted = ->
      job.get('startTime')

    div {className: 'row'},
      div {className: 'col-md-6'}, 'RunId ' + job.get('runId')
      div {className: 'col-md-6'}, 'Duration ',
        if jobStarted()
          Duration({startTime: job.get('startTime'), endTime: job.get('endTime')})
        else
          'N/A'

  _renderRunTimesRow: (job) ->
    renderDate = (pdate) ->
      if pdate
        date.format(pdate)
      else
        'N/A'
    div {className: 'row'},
      div {className: 'col-md-6'}, 'Start ',
        renderDate(job.get('startTime'))
      div {className: 'col-md-6'}, 'End ',
        renderDate(job.get('endTime'))

  _renderParamsRow: (job) ->
    status = job.get 'status'
    result = job.get 'result'
    exceptionId = job.getIn ['result', 'exceptionId'] if result
    message =  job.getIn ['result', 'message'] if result
    div {className: 'row'},
      div {className: 'col-md-6'},
        h4 null, 'Params '
        Tree {data: job.get('params')}
      div {className: 'col-md-6'},
        h4 null,'Results '
        if status == 'error'
          div {className: 'alert alert-danger'},
            if exceptionId
              span null, 'ExceptionId ' + exceptionId
            p null, message
        else
          Tree {data: result} if result


  _renderGeneralInfoRow: (job) ->
    console.log 'job', job.toJS()
    component = ComponentsStore.getComponent(job.get 'component')
    div {className: 'row'},
      div {className: 'col-md-6'},
        span {className: 'form-control-static'},
          ComponentIcon {component: component, size: '32'}
          ' '
          ComponentName {component: component}
        ' '
        span {className: 'label label-info'},job.get('command')
      div {className: 'col-md-6'},
        span null, 'Created By'
          ' '
          strong null, job.getIn(['token', 'description'])
          ' on '
          date.format(job.get('createdTime'))

  _renderLogRow: (job) ->
    div {className: 'col-md-12'},
      h4 null, 'Log'
      Events
        params:
          runId: job.get('runId')
        autoReload: job.get('status') == 'waiting' || job.get('status') == 'processing'


  render: ->
    job = @state.job
    console.log 'job render', job.toJS()
    div {className: 'container-fluid kbc-main-content'},
      @_renderGeneralInfoRow(job)
      @_renderRunInfoRow(job)
      @_renderRunTimesRow(job)
      @_renderParamsRow(job)
      @_renderLogRow(job)







module.exports = JobDetail
