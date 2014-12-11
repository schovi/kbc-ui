React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

# actions and stores
OrchestrationsActionCreators = require '../../../ActionCreators.coffee'
OrchestrationStore = require '../../../stores/OrchestrationsStore.coffee'
ComponentsStore = require '../../../../components/stores/ComponentsStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

# React components
OrchestrationsNav = React.createFactory(require './../orchestration-detail/OrchestrationsNav.coffee')
SearchRow = React.createFactory(require '../../../../../react/common/SearchRow.coffee')
TasksTable = React.createFactory(require './TasksTable.coffee')
TasksEditor = React.createFactory(require './TasksEditor.coffee')

{div, button} = React.DOM

OrchestrationTasks = React.createClass
  displayName: 'OrchestrationTasks'
  mixins: [createStoreMixin(OrchestrationStore, ComponentsStore)]

  getStateFromStores: ->
    orchestrationId = RoutesStore.getRouterState().getIn ['params', 'orchestrationId']
    return {
      orchestration: OrchestrationStore.get orchestrationId
      tasks: OrchestrationStore.getOrchestrationTasks orchestrationId
      components: ComponentsStore.getAll()
      filter: OrchestrationStore.getFilter()
      isEditing: false
    }

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  _handleFilterChange: (query) ->
    OrchestrationsActionCreators.setOrchestrationsFilter(query)

  _startEditing: ->
    @setState
      isEditing: true

  render: ->
    div {className: 'container-fluid'},
      div {className: 'col-md-3 kb-orchestrations-sidebar kbc-main-nav'},
        div {className: 'kbc-container'},
          SearchRow(onChange: @_handleFilterChange, query: @state.filter)
          OrchestrationsNav()
      div {className: 'col-md-9 kb-orchestrations-main kbc-main-content-with-nav'},
        if @state.isEditing
          div null,
            TasksEditor
              tasks: @state.tasks
              components: @state.components
        else
          div null,
            TasksTable
              tasks: @state.tasks
              components: @state.components
            button onClick: @_startEditing, className: 'btn btn-primary',
              'Edit vole'


module.exports = OrchestrationTasks