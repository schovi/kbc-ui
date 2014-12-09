React = require 'react'
OrchestrationActionCreators = require '../ActionCreators.coffee'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
RunOrchestrationModal = React.createFactory(require '../modals/RunOrchestration.coffee')

{button, span, i} = React.DOM

###
  Enabled/Disabled orchestration button with tooltip
###
OrchestrationRunButton = React.createClass
  displayName: 'OrchestrationRunButton'
  propTypes:
    orchestration: React.PropTypes.object.isRequired

  render: ->
    OverlayTrigger
      overlay: Tooltip null, 'Run'
      key: 'run'
      placement: 'top'

    ,
      ModalTrigger modal: RunOrchestrationModal(orchestration: @props.orchestration),
        button
          className: 'btn btn-link'
          onClick: @_runOrchestrationModal
        ,
          i className: 'fa fa-fw fa-play'

  _runOrchestrationModal: (e) ->
    console.log 'run orch'
    e.stopPropagation()
    e.preventDefault()

module.exports = OrchestrationRunButton
