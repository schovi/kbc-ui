React = require 'react'
Immutable = require 'immutable'

OrchestrationsActionCreators = require '../../actions/OrchestrationsActionCreators.coffee'
OrchestrationStore = require '../../stores/OrchestrationStore.coffee'
OrchestrationRow = React.createFactory(require './OrchestrationRow.coffee')
OrchestrationsSearch = React.createFactory(require './OrchestrationsSearch.coffee')

getStateFromStores = ->
  orchestrations: OrchestrationStore.getFiltered()
  isLoading: OrchestrationStore.getIsLoading()

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

  render: ->
    div {className: 'container-fluid'},
      'Loading: ' + @state.isLoading
      span className: 'fa fa-refresh', onClick: @_handleRefreshClick
      OrchestrationsSearch()
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