React = require 'react'

_ = require 'underscore'
{ModalFooter, Modal, ModalHeader, ModalTitle, ModalBody} = require('react-bootstrap')
{button, strong, div, h2, span, h4, section, p} = React.DOM
ApplicationStore = require '../../../../../stores/ApplicationStore'
{Map} = require 'immutable'
{Loader} = require 'kbc-react-components'


Button = React.createFactory(require('react-bootstrap').Button)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
RouterStore = require('../../../../../stores/RoutesStore')
{i, span, div, p, strong, form, input, label, div} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)


module.exports = React.createClass

  displayName: 'TdeOrchestrationRow'
  propTypes:
    updateLocalStateFn: React.PropTypes.func
    localState: React.PropTypes.object
    uploadComponentId: React.PropTypes.string

  render: ->
    span null,
      Button
        className: 'btn btn-default'
        onClick: =>
          @props.updateLocalStateFn('show', true)
      ,
        'Add Upload task To Orchestration'
      @_renderModal()

  _renderModal: ->
    show = !!@props.localState?.get('show')
    React.createElement Modal,
      show: show
      onHide: =>
        @props.updateLocalStateFn(false)
      title: 'Add Upload task To Orchestration'
    ,
      div null, 'todo!'
