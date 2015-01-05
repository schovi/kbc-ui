React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

OrchestrationActionCreators = require '../../ActionCreators.coffee'

{div, p, strong} = React.DOM

RunOrchestration = React.createClass
  displayName: 'RunOrchestration'
  propTypes:
    orchestration: React.PropTypes.object.isRequired

  getInitialState: ->
    isLoading: false

  render: ->
    Modal title: "Run orchestration #{@props.orchestration.get('name')}", onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        p null,
          'You are about to run the orchestration ',
           strong null, @props.orchestration.get('name'),
           ' manually and the notifications will be sent only to you.'
      div className: 'modal-footer',
        ButtonToolbar null,
          Button onClick: @props.onRequestHide,
            'Cancel'
          Button bsStyle: 'primary', onClick: @_handleRun, disabled: @state.isLoading,
            'Run'

  _handleRun: ->

    @setState
      isLoading: true

    OrchestrationActionCreators
    .runOrchestration(@props.orchestration.get('id'))
    .then(@props.onRequestHide)




module.exports = RunOrchestration