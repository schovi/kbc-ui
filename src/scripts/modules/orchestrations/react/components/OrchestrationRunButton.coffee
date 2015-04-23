React = require 'react'
OrchestrationActionCreators = require '../../ActionCreators'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
RunOrchestrationModal = React.createFactory(require '../modals/RunOrchestration')

{button, span, i} = React.DOM

###
  Enabled/Disabled orchestration button with tooltip
###
OrchestrationRunButton = React.createClass
  displayName: 'OrchestrationRunButton'
  propTypes:
    orchestration: React.PropTypes.object.isRequired
    notify: React.PropTypes.bool

  getDefaultProps: ->
    notify: false

  render: ->
    OverlayTrigger
      overlay: Tooltip null, 'Run'
      key: 'run'
      placement: 'top'

    ,
      ModalTrigger modal: RunOrchestrationModal(
        orchestration: @props.orchestration
        notify: @props.notify
      ),
        button
          className: 'btn btn-link'
          onClick: @_runOrchestrationModal
        ,
          i className: 'fa fa-fw fa-play'

  _runOrchestrationModal: (e) ->
    e.stopPropagation()
    e.preventDefault()

module.exports = OrchestrationRunButton
