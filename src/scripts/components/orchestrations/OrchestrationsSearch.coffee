
React = require 'react'
OrchestrationStore = require '../../stores/OrchestrationStore.coffee'
OrchestrationsActionCreators = require '../../actions/OrchestrationsActionCreators.coffee'
SearchRow = React.createFactory(require '../common/SearchRow.coffee')

getStateFromStores = ->
  filter: OrchestrationStore.getFilter()

OrchestrationsSearch = React.createClass(
  displayName: 'OrchestrationsSearch'

  getInitialState: ->
    getStateFromStores()

  _handleFilterChange: (query) ->
    OrchestrationsActionCreators.setOrchestrationsFilter(query)

  render: ->
    SearchRow(onChange: @_handleFilterChange, query: @state.filter)

)

module.exports = OrchestrationsSearch