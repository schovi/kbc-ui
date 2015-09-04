React = require 'react'

_ = require 'underscore'
{ModalFooter, Modal, ModalHeader, ModalTitle, ModalBody} = require('react-bootstrap')
{button, strong, div, h2, span, h4, section, p} = React.DOM
ApplicationStore = require '../../../../../stores/ApplicationStore'
{Map} = require 'immutable'


Loader = React.createFactory(require('kbc-react-components').Loader)
Button = React.createFactory(require('react-bootstrap').Button)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
RouterStore = require('../../../../../stores/RoutesStore')
{option, i, span, div, p, strong, form, input, label, div} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)


module.exports = React.createClass

  displayName: 'TdeOrchestrationRow'
  propTypes:
    updateLocalStateFn: React.PropTypes.func
    localState: React.PropTypes.object
    uploadComponentId: React.PropTypes.string
    orchestrationsList: React.PropTypes.object
    isLoadingOrchestrations: React.PropTypes.bool
    selectOrchestrationFn: React.PropTypes.func
    selectedOrchestration: React.PropTypes.string
    description: React.PropTypes.string
    onAppendClick: React.PropTypes.func
    isAppending: React.PropTypes.bool
    account: React.PropTypes.object

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
        @props.updateLocalStateFn('show', false)
      title: 'Append Export and Upload tasks To Orchestration'
    ,
      div className: 'modal-body',
        div className: 'form form-horizontal',
          if @props.isLoadingOrchestrations
            Loader()
          else
            @_renderOrchestrationsSelect()
      div className: 'modal-footer',
        ButtonToolbar null,
          if @props.isAppending
            Loader()
          Button
            disabled: @props.isAppending
            onClick: =>
              @props.updateLocalStateFn('show', false)
            bsStyle: 'link'
          ,
            'Cancel'
          Button
            bsStyle: 'success'
            disabled: not @props.selectedOrchestration or @props.isAppending
            onClick: =>
              @props.onAppendClick()
          ,
            'Append'


  _renderOrchestrationsSelect: ->
    options = @props.orchestrationsList.map((value, key) ->
      keyStr = key
      option
        value: keyStr
        key: keyStr
      ,
        value.get 'name'
    ).toArray()
    options.push(
      option
        key: ''
        value: ''
      , ''
    )

    Input
      type: 'select'
      labelClassName: 'col-sm-4'
      wrapperClassName: 'col-sm-8'
      label: "Select Orchestration:"
      value: @props.selectedOrchestration or ''
      placeholder: ''
      help: "Export of onfigured tables to TDE files and their upload \
       to #{@props.description} will be appended as tasks to the selected orchestration"
      onChange: (e) =>
        value = e.target.value
        @props.selectOrchestrationFn(value)
    ,
      options
