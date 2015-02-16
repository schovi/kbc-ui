React = require 'react'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
Modal = React.createFactory(require('react-bootstrap').Modal)
Button = React.createFactory(require('react-bootstrap').Button)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)


{a, i, div, button} = React.DOM

RunModal = React.createFactory React.createClass

  _handleRun: ->
    @props.onRequestHide()
    @props.onRequestRun()

  render: ->
    Modal
      title: 'Run extraction'
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        'You are about to run extraction.'
      div className: 'modal-footer',
        ButtonToolbar null,
          Button
            bsStyle: 'link'
            onClick: @props.onRequestHide
          ,
            'Close'
          Button
            bsStyle: 'primary'
            onClick: @_handleRun
          ,
            'Run'

module.exports = React.createClass
  displayName: 'RunExtraction'
  propTypes:
    mode: React.PropTypes.oneOf ['button', 'link']
    component: React.PropTypes.string.isRequired
    runParams: React.PropTypes.object.isRequired

  getDefaultProps: ->
    mode: 'button'

  getInitialState: ->
    isLoading: false

  _handleRunStart: ->
    @setState
      isLoading: true

    InstalledComponentsActionCreators
    .runComponent
      component: @props.component
      data: @props.runParams
    .then @_handleStarted

  _handleStarted: ->
    @setState
      isLoading: false

  render: ->
    ModalTrigger
      modal: RunModal
        onRequestRun: @_handleRunStart
    ,
      if @props.mode == 'button'
        @_renderButton()
      else
        @_renderLink()

  _renderButton: ->
    button
      className: 'btn btn-link'
      onClick: (e) ->
        e.stopPropagation()
        e.preventDefault()
    ,
      @_renderIcon()

  _renderLink: ->
    a
      onClick: (e) ->
        e.stopPropagation()
        e.preventDefault()
    ,
      @_renderIcon()
      ' Run Extraction'

  _renderIcon: ->
    if @state.isLoading
      i className: 'fa fa-refresh fa-fw fa-spin'
    else
      i className: 'fa fa-fw fa-play'