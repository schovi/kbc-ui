React = require 'react'

OrchestrationStore = require '../../stores/OrchestrationStore.coffee'
OrchestrationRow = React.createFactory(require './OrchestrationRow.coffee')
SearchRow = React.createFactory(require './SearchRow.coffee')

getStateFromStores = ->
  orchestrations: OrchestrationStore.getAll()

{div, span, strong} = React.DOM

Index = React.createClass
  displayName: 'OrchestrationsIndex'
  getInitialState: ->
    getStateFromStores()
  tableHeader: ->
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

  render: ->
    childs = @state.orchestrations.map((orchestration) ->
      OrchestrationRow {orchestration: orchestration, key: orchestration.get('id')}
    , @).toArray()

    div {className: 'container-fluid'},
      SearchRow()
      div className: 'table table-striped table-hover',
        @tableHeader()
        div className: 'tbody',
          childs

module.exports = Index