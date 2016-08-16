React = require 'react'
InstalledComponentsActionCreators = require '../../../components/InstalledComponentsActionCreators'

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
Modal = React.createFactory(require('react-bootstrap').Modal)
Button = React.createFactory(require('react-bootstrap').Button)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)


{a, i, div} = React.DOM

RunModal = React.createClass

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
    configId: React.PropTypes.string.isRequired

  getInitialState: ->
    isLoading: false

  _handleRunStart: ->
    @setState
      isLoading: true

    InstalledComponentsActionCreators
    .runComponent
      component: 'ex-google-drive'
      data:
        account: @props.runParams.account
    .then @_handleStarted

  _handleStarted: ->
    @setState
      isLoading: false

  render: ->
    ModalTrigger
      modal: RunModal
        onRequestRun: @_handleRunStart
    ,
      a null,
        @_renderIcon()
        ' Run Extraction!'

  _renderIcon: ->
    if @state.isLoading
      i className: 'fa fa-refresh fa-fw fa-spin'
    else
      i className: 'fa fa-fw fa-play'
