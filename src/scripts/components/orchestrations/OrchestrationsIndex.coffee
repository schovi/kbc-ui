React = require 'react'
Immutable = require 'immutable'

OrchestrationsActionCreators = require '../../actions/OrchestrationsActionCreators.coffee'
OrchestrationStore = require '../../stores/OrchestrationStore.coffee'

OrchestrationRow = React.createFactory(require './OrchestrationRow.coffee')
SearchRow = React.createFactory(require '../common/SearchRow.coffee')
RefreshIcon = React.createFactory(require '../common/RefreshIcon.coffee')

getStateFromStores = ->
  orchestrations: OrchestrationStore.getFiltered()
  isLoading: OrchestrationStore.getIsLoading()
  isLoaded: OrchestrationStore.getIsLoaded()
  filter: OrchestrationStore.getFilter()

{div, span, strong} = React.DOM

Index = React.createClass
  displayName: 'OrchestrationsIndex'

  getInitialState: ->
    getStateFromStores()

  componentDidMount: ->
    OrchestrationStore.addChangeListener(@_onChange)
    OrchestrationsActionCreators.loadOrchestrations()

  componentWillUnmount: ->
    OrchestrationStore.removeChangeListener(@_onChange)

  shouldComponentUpdate: (nextProps, nextState) ->
    !Immutable.is(nextState.orchestrations, @state.orchestrations) ||
      nextState.isLoading != @state.isLoading

  _handleRefreshClick: (e) ->
    OrchestrationsActionCreators.loadOrchestrationsForce()

  _handleFilterChange: (query) ->
    OrchestrationsActionCreators.setOrchestrationsFilter(query)

  render: ->
    div {className: 'container-fluid'},
      RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick
      SearchRow(onChange: @_handleFilterChange, query: @state.filter, className: 'row kbc-search-row')
      if @state.isLoaded
        if @state.orchestrations.count() then @_renderTable() else @_renderEmptyState()

  _renderEmptyState: ->
    div null, 'No orchestrations found'

  _renderTable: ->
    childs = @state.orchestrations.map((orchestration) ->
      OrchestrationRow {orchestration: orchestration, key: orchestration.get('id')}
    , @).toArray()

    div className: 'table table-striped table-hover',
      @_renderTableHeader()
      div className: 'tbody',
        childs

  _renderTableHeader: ->
    (div {className: 'thead', key: 'table-header'},
      (div {className: 'tr'},
        (span {className: 'th'},
          (strong null, 'Name')
        ),
        (span {className: 'th'},
          (strong null, 'Last Run')
        ),
        (span {className: 'th'},
          (strong null, 'Duration')
        ),
        (span {className: 'th'},
          (strong null, 'Schedule')
        ),
        (span {className: 'th'})
      )
    )

  _onChange: ->
    @setState(getStateFromStores())

module.exports = Index