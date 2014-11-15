React = require 'react'

OrchestrationsNav = React.createFactory(require './OrchestrationsNav.coffee')

{div} = React.DOM

OrchestrationDetail = React.createClass
  displayName: 'OrchestrationDetail'
  render: ->
    div {className: 'container-fluid'},
      div {className: 'row'},
        div {className: 'col-md-3 kb-orchestrations-sidebar'},
          OrchestrationsNav()
        div {className: 'col-md-9 kb-orchestrations-main'},
          div {}, "Orchestration #{@props.params.id}"


module.exports = OrchestrationDetail