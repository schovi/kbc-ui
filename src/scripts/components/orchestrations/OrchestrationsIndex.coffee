React = require 'react'
_ = require 'underscore'

OrchestrationStore = require '../../stores/OrchestrationStore.coffee'
OrchestrationRow = React.createFactory(require './OrchestrationRow.coffee')

getStateFromStores = ->
  orchestrations: OrchestrationStore.getAll()

{div, span, strong} = React.DOM

Index = React.createClass
  displayName: 'OrchestrationsIndex'
  getInitialState: ->
    getStateFromStores()
  tableHeader: ->
    (div {className: 'list-group-item', key: 'table-header'},
      (span {className: 'row'},
        (span {className: 'col-md-4 kb-info kb-name-header'},
          (strong null, 'Name')
        ),
        (span {className: 'col-md-2 kb-info'},
          (strong null, 'Last Run')
        ),
        (span {className: 'col-md-2 kb-info'},
          (strong null, 'Duration')
        ),
        (span {className: 'col-md-2 kb-info'},
          (strong null, 'Schedule')
        ),
        (span {className: 'col-md-2 kb-info'})
      )
    )

  render: ->
    childs = _.map(@state.orchestrations, (orchestration) ->
      OrchestrationRow {orchestration: orchestration, key: orchestration.id}
    , @)

    childs.unshift(@tableHeader())

    div {className: 'container-fluid'},
      div className: 'list-group kb-orchestrations-nav',
        childs

module.exports = Index