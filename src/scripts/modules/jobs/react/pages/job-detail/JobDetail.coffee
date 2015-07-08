React = require('react')
SoundNotifications = require '../../../../../utils/SoundNotifications'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ApplicationStore = require '../../../../../stores/ApplicationStore'
JobsStore = require('../../../stores/JobsStore')
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

Events = React.createFactory(require '../../../../sapi-events/react/Events')
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName')
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))
Duration = React.createFactory(require('../../../../../react/common/Duration'))
JobStats = require './JobStatsContainer'
GoodDataStatsContainer = require './GoodDataStatsContainer'
{PanelGroup, Panel} = require 'react-bootstrap'
{Link} = require 'react-router'
getComponentId = require '../../../getJobComponentId'
JobStatusLabel = React.createFactory(require('../../../../../react/common/common').JobStatusLabel)
ActionCreators = require '../../../ActionCreators'

ComponentConfigurationLink = require '../../../../components/react/components/ComponentConfigurationLink'

date = require '../../../../../utils/date'
{Tree} = require 'kbc-react-components'
{strong,div, h2, span, h4, section, p} = React.DOM

accordionHeader = (text, isActive) ->
  span null,
    span className: 'table',
      span className: 'tbody',
        span className: 'tr',
            span className: 'td',
              h4  null,
                if isActive
                  span className: 'fa fa-fw fa-angle-down'
                else
                  span className: 'fa fa-fw fa-angle-right'
                text

module.exports = React.createClass
  mixins: [createStoreMixin(JobsStore, InstalledComponentsStore)]


  getStateFromStores: ->
    job = JobsStore.get RoutesStore.getCurrentRouteIntParam('jobId')

    configuration = null
    if job.hasIn ['params', 'config']
      config = job.getIn ['params', 'config']
      configuration = InstalledComponentsStore.getConfig(getComponentId(job), config)

    job: job
    configuration: configuration


  getInitialState: ->
    job = JobsStore.get RoutesStore.getCurrentRouteIntParam('jobId')
    activeAccordion: if job.get('component') == 'gooddata-writer' then 'gdresults' else 'stats'

  componentDidUpdate: (prevProps, prevState) ->
    currentStatus = @state.job.get 'status'
    prevStatus = prevState.job.get 'status'
    return if currentStatus == prevStatus
    switch currentStatus
      when 'success'
        SoundNotifications.success()
      when 'error', 'cancelled', 'canceled', 'terminated'
        SoundNotifications.crash()

  _handleChangeActiveAccordion: (activeKey) ->
    @setState
      activeAccordion: if activeKey == @state.activeAccordion then '' else activeKey

  render: ->
    job = @state.job
    div {className: 'container-fluid kbc-main-content'},
      @_renderGeneralInfoRow(job)
      @_renderRunInfoRow(job)
      @_renderErrorResultRow(job) if job.get('status') == 'error'
      @_renderAccordion(job)
      @_renderLogRow(job)


  _renderErrorResultRow: (job) ->
    result = job.get 'result'
    exceptionId = job.getIn ['result', 'exceptionId'] if result
    message =  job.getIn ['result', 'message'] if result
    div {className: 'row row-alert'},
      div {className: 'alert alert-danger'},
        p null,
          React.DOM.strong null, message
        div null,
          if exceptionId
            span null, 'ExceptionId ' + exceptionId
          React.DOM.button
            className: 'btn btn-danger'
            onClick: @_contactSupport
            style:
              marginLeft: '15px'
          ,
            'Contact Support'


  _renderRunInfoRow: (job) ->
    componentId = getComponentId(job)
    if @state.configuration
      configurationLink = span null,
        React.createElement ComponentConfigurationLink,
          componentId: componentId
          configId: @state.configuration.get 'id'
        ,
          @state.configuration.get 'name'
    else if componentId == 'orchestrator'
      configurationLink = span null,
        React.createElement Link,
          to: 'orchestration'
          params:
            orchestrationId: job.getIn ['params', 'orchestration', 'id']
        ,
          job.getIn ['params', 'orchestration', 'name']
    else
      configurationLink = null
    jobStarted = ->
      job.get('startTime')
    renderDate = (pdate) ->
      if pdate
        date.format(pdate)
      else
        'N/A'

    div {className: 'table kbc-table-border-vertical kbc-detail-table', style: {marginBottom: 0}},
      div {className: 'tr'},
        div {className: 'td'},
          div {className: 'row'},
            span {className: 'col-md-3'},
              'Configuration'
            strong {className: 'col-md-9'},
              configurationLink
          div {className: 'row'},
            span {className: 'col-md-3'},
              'Created'
            strong {className: 'col-md-9'},
              date.format(job.get('createdTime'))
          div {className: 'row'},
            span {className: 'col-md-3'},
              'Start'
            strong {className: 'col-md-9'},
              renderDate(job.get('startTime'))
          div {className: 'row'},
            span {className: 'col-md-3'},
              'Initialized '
            strong className: 'col-md-9',
              job.getIn(['token', 'description'])
          div {className: 'row'},
            span {className: 'col-md-3'},
              'RunId'
            strong {className: 'col-md-9'},
              job.get('runId')
        div {className: 'td'},
          div {className: 'row'},
            span {className: 'col-md-3'},
              'Command'
            strong {className: 'col-md-9'},
              span {className: 'label label-info'},job.get('command')
          div className: 'row',
            span className: 'col-md-3', 'Status '
            span className: 'col-md-9', JobStatusLabel status: job.get('status')
          div className: 'row',
            span className: 'col-md-3', 'End '
            strong className: 'col-md-9', renderDate(job.get('endTime'))
          div className: 'row',
            span className: 'col-md-3', 'Token '
            strong className: 'col-md-9', job.getIn(['token', 'description'])
          div {className: 'row'},
            span {className: 'col-md-3'},
              'Duration'
            strong {className: 'col-md-9'},
              if jobStarted()
                Duration({startTime: job.get('startTime'), endTime: job.get('endTime')})
              else
                'N/A'

  _renderAccordion: (job) ->
    React.createElement PanelGroup,
      accordion: true
      className: 'kbc-accordion kbc-panel-heading-with-table'
      activeKey: @state.activeAccordion
      onSelect: @_handleChangeActiveAccordion
    ,
      if @_isGoodDataWriter()
        React.createElement Panel,
          header: accordionHeader('Tasks', @state.activeAccordion == 'gdresults')
          eventKey: 'gdresults'
        ,
        React.createElement GoodDataStatsContainer, {job: @state.job}

      React.createElement Panel,
        header: accordionHeader('Parameters & Results', @state.activeAccordion == 'params')
        eventKey: 'params'
      ,
        @_renderParamsRow(job)

      React.createElement Panel,
        header: accordionHeader('Storage Stats', @state.activeAccordion == 'stats')
        eventKey: 'stats'
      ,
        React.createElement JobStats,
          runId: job.get 'runId'
          autoRefresh: !job.get 'endTime'

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
    componentId = getComponentId(job)
    component = ComponentsStore.getComponent(componentId)
    component = ComponentsStore.unknownComponent(componentId) if !component

    div {className: 'row'},
      div {className: 'col-md-6'},
        span {className: ''},
          ComponentIcon {component: component, size: '32'}
          ' '
          ComponentName {component: component}

  _renderLogRow: (job) ->
    div {className: 'col-md-12'},
      h2 null, 'Log'
      Events
        params:
          runId: job.get('runId')
        autoReload: job.get('status') == 'waiting' || job.get('status') == 'processing'

  _isGoodDataWriter: ->
    getComponentId(@state.job) == 'gooddata-writer'

  _contactSupport: ->
    Zenbox.init
      dropboxID: ApplicationStore.getKbcVars().getIn(['zendesk', 'direct', 'dropboxId'])
      url: ApplicationStore.getKbcVars().getIn(['zendesk', 'direct', 'url'])
      request_subject: "Help with job #{@state.job.get('id')}"
    Zenbox.show()
