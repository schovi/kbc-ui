React = require 'react'
Router = require 'react-router'

OrchestrationsActionCreators = require '../../actions/OrchestrationsActionCreators.coffee'
OrchestrationStore = require '../../stores/OrchestrationStore.coffee'

OrchestrationsNav = React.createFactory(require './OrchestrationsNav.coffee')
OrchestrationsSearch = React.createFactory(require './OrchestrationsSearch.coffee')

{div} = React.DOM



OrchestrationDetail = React.createClass
  displayName: 'OrchestrationDetail'
  mixins: [Router.State]

  _getId: ->
    # using getParams method provided by Router.State mixin
    parseInt(@getParams().id)

  _getStateFromStores: ->
    orchestrationId = @_getId()
    return {
      orchestration: OrchestrationStore.get orchestrationId
      isLoading: OrchestrationStore.getIsOrchestrationLoading orchestrationId
    }

  getInitialState: ->
    @_getStateFromStores()

  componentDidMount: ->
    OrchestrationStore.addChangeListener(@_onChange)
    OrchestrationsActionCreators.loadOrchestration(@_getId())

  componentWillReceiveProps: ->
    @setState(@_getStateFromStores())
    OrchestrationsActionCreators.loadOrchestration(@_getId())

  componentWillUnmount: ->
    OrchestrationStore.removeChangeListener(@_onChange)

  _onChange: ->
    @setState(@_getStateFromStores())

  render: ->
    if @state.isLoading
      text = 'loading ...'
    else
      if @state.orchestration
        text = 'Orchestration ' + @state.orchestration.get('id') + ' ' + @state.orchestration.get('name')
      else
        text = 'Orchestration not found'

    div {className: 'container-fluid'},
      div {className: 'row'},
        div {className: 'col-md-3 kb-orchestrations-sidebar'},
          OrchestrationsSearch()
          OrchestrationsNav()
        div {className: 'col-md-9 kb-orchestrations-main'},
          div {}, text


module.exports = OrchestrationDetail