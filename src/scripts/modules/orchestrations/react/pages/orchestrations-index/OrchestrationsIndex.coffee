React = require 'react'
Immutable = require 'immutable'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

OrchestrationsActionCreators = require '../../../ActionCreators'
OrchestrationStore = require '../../../stores/OrchestrationsStore'

OrchestrationRow = React.createFactory(require './OrchestrationRow')
SearchRow = React.createFactory(require '../../../../../react/common/SearchRow')
RefreshIcon = React.createFactory(require('kbc-react-components').RefreshIcon)
ImmutableRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

NewOrchestrationButton = require '../../components/NewOrchestionButton'


{div, span, strong, h2, p} = React.DOM

Index = React.createClass
  displayName: 'OrchestrationsIndex'
  mixins: [createStoreMixin(OrchestrationStore), ImmutableRendererMixin]

  _handleFilterChange: (query) ->
    OrchestrationsActionCreators.setOrchestrationsFilter(query)

  getStateFromStores: ->
    totalOrchestrationsCount: OrchestrationStore.getAll().count()
    orchestrations: OrchestrationStore.getFiltered()
    pendingActions: OrchestrationStore.getPendingActions()
    isLoading: OrchestrationStore.getIsLoading()
    isLoaded: OrchestrationStore.getIsLoaded()
    filter: OrchestrationStore.getFilter()

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      if @state.totalOrchestrationsCount
        SearchRow(onChange: @_handleFilterChange, query: @state.filter, className: 'row kbc-search-row')
        if @state.orchestrations.count()
          @_renderTable()
        else
          @_renderNotFound()
      else
        @_renderEmptyState()

  _renderEmptyState: ->
    div className: 'row',
      h2 null,
        'Orchestrations allows you to group together related tasks and schedule it\'s execution.'
      p null,
        React.createElement NewOrchestrationButton,
          buttonLabel: 'Get Started Now'


  _renderNotFound: ->
    div {className: 'table table-striped'},
      div {className: 'tfoot'},
        div {className: 'tr'},
          div {className: 'td'}, 'No orchestrations found'

  _renderTable: ->
    childs = @state.orchestrations.map((orchestration) ->
      OrchestrationRow
        orchestration: orchestration
        pendingActions: @state.pendingActions.get(orchestration.get('id'), Immutable.Map())
        key: orchestration.get 'id'
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

module.exports = Index
