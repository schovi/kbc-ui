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
      title: @props.title
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        @props.body
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
    title: React.PropTypes.string.isRequired
    body: React.PropTypes.object.isRequired
    mode: React.PropTypes.oneOf ['button', 'link']
    component: React.PropTypes.string.isRequired
    runParams: React.PropTypes.func.isRequired
    method: React.PropTypes.string.isRequired

  getDefaultProps: ->
    mode: 'button'
    method: 'run'

  getInitialState: ->
    isLoading: false

  _handleRunStart: ->
    @setState
      isLoading: true

    params =
      method: @props.method
      component: @props.component
      data: @props.runParams()

    InstalledComponentsActionCreators
    .runComponent params
    .then @_handleStarted

  _handleStarted: ->
    @setState
      isLoading: false

  render: ->
    ModalTrigger
      modal: RunModal
        title: @props.title
        body: @props.body
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
      ' ' + @props.title

  _renderIcon: ->
    if @state.isLoading
      i className: 'fa fa-refresh fa-fw fa-spin'
    else
      i className: 'fa fa-fw fa-play'
