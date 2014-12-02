React = require 'react'
Router = require 'react-router'

createStoreMixin = require '../../mixins/createStoreMixin.coffee'

# actions and stores
OrchestrationsActionCreators = require '../../actions/OrchestrationsActionCreators.coffee'
OrchestrationStore = require '../../stores/OrchestrationStore.coffee'
OrchestrationJobsStore = require '../../stores/OrchestrationJobsStore.coffee'

# React components
OrchestrationsNav = React.createFactory(require './OrchestrationsNav.coffee')
SearchRow = React.createFactory(require '../common/SearchRow.coffee')
JobsTable = React.createFactory(require './jobs-table/JobsTable.coffee')

{div, h2} = React.DOM


OrchestrationDetail = React.createClass
  displayName: 'OrchestrationDetail'
  mixins: [Router.State, createStoreMixin(OrchestrationStore, OrchestrationJobsStore)]


  getStateFromStores: ->
    orchestrationId = @_getOrchestrationId()
    return {
      orchestration: OrchestrationStore.get orchestrationId
      isLoading: OrchestrationStore.getIsOrchestrationLoading orchestrationId
      filter: OrchestrationStore.getFilter()
      jobs: OrchestrationJobsStore.getOrchestrationJobs orchestrationId
      jobsLoading: OrchestrationJobsStore.isLoading orchestrationId
    }

  _getOrchestrationId: ->
    # using getParams method provided by Router.State mixin
    parseInt(@getParams().orchestrationId)


  componentDidMount: ->
    OrchestrationsActionCreators.loadOrchestration(@_getOrchestrationId())
    OrchestrationsActionCreators.loadOrchestrationJobs(@_getOrchestrationId())

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())
    OrchestrationsActionCreators.loadOrchestration(@_getOrchestrationId())
    OrchestrationsActionCreators.loadOrchestrationJobs(@_getOrchestrationId())

  _handleFilterChange: (query) ->
    OrchestrationsActionCreators.setOrchestrationsFilter(query)

  _handleJobsReload: ->
    OrchestrationsActionCreators.loadOrchestrationJobs(@_getOrchestrationId())

  render: ->
    if @state.isLoading
      text = 'loading ...'
    else
      if @state.orchestration
        text = 'Orchestration ' + @state.orchestration.get('id') + ' ' + @state.orchestration.get('name')
      else
        text = 'Orchestration not found'

    div {className: 'container-fluid'},
      div {className: 'col-md-3 kb-orchestrations-sidebar kbc-main-nav'},
        SearchRow(onChange: @_handleFilterChange, query: @state.filter)
        OrchestrationsNav()
      div {className: 'col-md-9 kb-orchestrations-main kbc-main-content-with-nav'},
        div {className: 'row kbc-header'},
          div {className: 'kbc-title'},
            h2 null,
              text
          div {className: 'kbc-buttons'},
            ''
        JobsTable(
          jobs: @state.jobs
          jobsLoading: @state.jobsLoading
          onJobsReload: @_handleJobsReload
        )


module.exports = OrchestrationDetail