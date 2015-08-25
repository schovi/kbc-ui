React = require 'react'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
{OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Loader = React.createFactory(require('kbc-react-components').Loader)
RoutesStore = require '../../../../stores/RoutesStore'
classnames = require 'classnames'

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
          React.createElement Button,
            bsStyle: 'link'
            onClick: @props.onRequestHide
          ,
            'Close'
          React.createElement Button,
            bsStyle: 'primary'
            onClick: @_handleRun
          ,
            'Run'

module.exports = React.createClass
  displayName: 'RunExtraction'
  propTypes:
    title: React.PropTypes.string.isRequired
    mode: React.PropTypes.oneOf ['button', 'link']
    component: React.PropTypes.string.isRequired
    runParams: React.PropTypes.func.isRequired
    method: React.PropTypes.string.isRequired
    icon: React.PropTypes.string.isRequired
    label: React.PropTypes.string
    redirect: React.PropTypes.bool
    tooltip: React.PropTypes.string
    disabled: React.PropTypes.bool
    disabledReason: React.PropTypes.string
    tootlipPlacement: React.PropTypes.string

  getDefaultProps: ->
    mode: 'button'
    method: 'run'
    icon: 'fa-play'
    redirect: false
    tooltip: 'Run'
    disabled: false
    disabledReason: ''
    tooltipPlacement: 'top'

  getInitialState: ->
    isLoading: false

  _handleRunStart: ->
    @setState
      isLoading: true

    params =
      method: @props.method
      component: @props.component
      data: @props.runParams()
      notify: !@props.redirect

    InstalledComponentsActionCreators
    .runComponent params
    .then @_handleStarted
    .catch (error) =>
      @setState
        isLoading: false
      throw error

  _handleStarted: (response) ->
    if @isMounted()
      @setState
        isLoading: false
    if @props.redirect
      RoutesStore.getRouter().transitionTo("jobDetail", {jobId: response.id})

  render: ->
    if @props.disabled
      React.createElement OverlayTrigger,
        overlay: React.createElement(Tooltip, null, @props.disabledReason)
        placement: @props.tooltipPlacement
      ,
        if @props.mode == 'button'
          @_renderButton()
        else
          @_renderLink()
    else
      if @props.mode == 'button'
        React.createElement OverlayTrigger,
          overlay: React.createElement(Tooltip, null, @props.tooltip)
          placement: @props.tooltipPlacement
        ,
          ModalTrigger
            modal: RunModal
              title: @props.title
              body: @props.children
              onRequestRun: @_handleRunStart
          ,
            @_renderButton()
      else
        ModalTrigger
          modal: RunModal
            title: @props.title
            body: @props.children
            onRequestRun: @_handleRunStart
        ,
          @_renderLink()

  _renderButton: ->
    React.createElement Button,
      className: 'btn btn-link'
      disabled: @props.disabled
      onClick: (e) ->
        e.stopPropagation()
        e.preventDefault()
    ,
      @_renderIcon()
      if @props.label
        ' ' + @props.label

  _renderLink: ->
    a
      className: classnames('text-muted': @props.disabled)
      onClick: (e) ->
        e.stopPropagation()
        e.preventDefault()
    ,
      @_renderIcon()
      ' ' + @props.title

  _renderIcon: ->
    if @state.isLoading
      Loader className: 'fa-fw'
    else
      i className: "fa fa-fw #{@props.icon}"
