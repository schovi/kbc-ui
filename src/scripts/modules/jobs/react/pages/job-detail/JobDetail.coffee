React = require('react')
SoundNotifications = require '../../../../../utils/SoundNotifications'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
JobsStore = require('../../../stores/JobsStore')
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
Events = React.createFactory(require '../../../../sapi-events/react/Events')
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName')
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))
Duration = React.createFactory(require('../../../../../react/common/Duration'))
JobStats = require './JobStatsContainer'
CollabsibleRow = require './CollabsibleRow'
{PanelGroup, Panel} = require 'react-bootstrap'

ComponentConfigurationLink = require '../../../../components/react/components/ComponentConfigurationLink'

date = require '../../../../../utils/date'
Tree = require '../../../../../react/common/Tree'
{strong,div, h2, span, h4, section, p} = React.DOM

JobDetail = React.createClass
  mixins: [createStoreMixin(JobsStore, InstalledComponentsStore)]

  getStateFromStores: ->
    job = JobsStore.get RoutesStore.getCurrentRouteIntParam('jobId')

    configuration = null
    if job.hasIn ['params', 'config']
      config = job.getIn ['params', 'config']
      configuration = InstalledComponentsStore.getConfig(job.get('component'), config)

    job: job
    configuration: configuration

  componentDidUpdate: (prevProps, prevState) ->
    currentStatus = @state.job.get 'status'
    prevStatus = prevState.job.get 'status'
    return if currentStatus == prevStatus
    switch currentStatus
      when 'success'
        SoundNotifications.success()
      when 'error', 'cancelled', 'canceled', 'terminated'
        SoundNotifications.crash()


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

  _renderAccordion: (job) ->
    React.createElement PanelGroup,
      accordion: true
      defaultActiveKey: 'stats'
    ,
      React.createElement Panel,
        header: 'Params and Results',
        eventKey: 'params'
      ,
        @_renderParamsRow(job)
      React.createElement Panel,
        header: 'Stats'
        eventKey: 'stats'
      ,
        React.createElement JobStats,
          runId: job.get 'runId'

  _renderParamsRow: (job) ->
    status = job.get 'status'
    result = job.get 'result'
    exceptionId = job.getIn ['result', 'exceptionId'] if result
    message =  job.getIn ['result', 'message'] if result
    div null,
      div {className: 'col-md-6'},
        h4 null, 'Params '
        React.createElement Tree, {data: job.get('params')}
      div {className: 'col-md-6'},
        h4 null,'Results '
        if status == 'error'
          div {className: 'alert alert-danger'},
            if exceptionId
              span null, 'ExceptionId ' + exceptionId
            p null, message
        else
          React.createElement Tree, {data: result} if result


  _renderGeneralInfoRow: (job) ->
    component = ComponentsStore.getComponent(job.get 'component')

    if @state.configuration
      configurationLink = span null,
        ' - '
        React.createElement ComponentConfigurationLink,
          componentId: component.get 'id'
          configId: @state.configuration.get 'id'
        ,
          @state.configuration.get 'name'
    else
      configurationLink = null

    div {className: 'row'},
      div {className: 'col-md-6'},
        span {className: 'form-control-static'},
          ComponentIcon {component: component, size: '32'}
          ' '
          ComponentName {component: component}
        configurationLink
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
    console.log 'configuration', @state.configuration?.toJS()
    job = @state.job
    div {className: 'container-fluid kbc-main-content'},
      @_renderGeneralInfoRow(job)
      @_renderRunInfoRow(job)
      @_renderRunTimesRow(job)
      @_renderAccordion(job)
      @_renderLogRow(job)







module.exports = JobDetail
