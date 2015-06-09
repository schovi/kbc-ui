React = require 'react'


actionCreators = require '../../../actionCreators'

{Modal, ModalTrigger, Input, Button, ButtonToolbar} = require 'react-bootstrap'

{div} = React.DOM
Loader = React.createFactory(require('kbc-react-components').Loader)


FIELD = 'incrementalLoad'

LoadTypeModal = React.createClass
  displayName: 'LoadTypeModal'
  propTypes:
    table: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired

  _handleModeRadioChange: (mode, e) ->
    if mode == 'full'
      @props.onChange
        incrementalLoad: false
    else
      @props.onChange
        incrementalLoad: 1

  _handleIncrementalDaysNumber: (e) ->
    @props.onChange
      incrementalLoad: parseInt e.target.value

  componentWillReceiveProps: (nextProps) ->
    isSavingCurrent = @props.table.get('savingFields').contains FIELD
    isSavingNew = nextProps.table.get('savingFields').contains FIELD
    if isSavingCurrent && !isSavingNew
      @props.onRequestHide()

  render: ->
    isSaving = @props.table.get('savingFields').contains FIELD
    if @props.table.hasIn(['editingFields', FIELD])
      incrementalLoad = @props.table.getIn ['editingFields', FIELD]
    else
      incrementalLoad = @props.table.getIn ['data', FIELD]

    numberInput = React.DOM.input
      type: 'number'
      value: parseInt(incrementalLoad)
      onChange: @_handleIncrementalDaysNumber
      className: 'form-control'
      style:
        width: '50px'
        display: 'inline-block'

    incrementalHelp = React.DOM.span null,
      'Data will be apended to dataset.'
      React.DOM.br
      'Only rows created or updated in last '
      numberInput
      ' '
      if incrementalLoad == 1 then 'day' else 'days'
      ' will be uploaded to the dataset.'

    React.createElement Modal,
      title: "Table #{@props.table.getIn ['data', 'name']} Load Type"
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        div className: 'form-horizontal',
          React.createElement Input,
            type: 'radio'
            wrapperClassName: 'col-sm-offset-2 col-sm-8'
            help: 'All data in GoodData dataset will be replaced by current data in source Storage API table.'
            label: 'Full Load'
            checked: !incrementalLoad
            onChange: @_handleModeRadioChange.bind @, 'full'
            disabled: isSaving
          React.createElement Input,
            type: 'radio'
            wrapperClassName: 'col-sm-offset-2 col-sm-8'
            help: incrementalHelp
            label: 'Incremental'
            checked: incrementalLoad > 0
            onChange: @_handleModeRadioChange.bind @, 'incremental'
            disabled: isSaving

      div className: 'modal-footer',
        Loader() if isSaving
        React.createElement ButtonToolbar,
          React.createElement Button,
            onClick: @props.onRequestHide
            bsStyle: 'link'
          ,
            'Cancel'
          React.createElement Button,
            onClick: @props.onSave
            bsStyle: 'success'
            disabled: isSaving
          ,
            'Save'



module.exports = React.createClass
  displayName: 'TableGdName'
  propTypes:
    table: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired

  _handleEditStart: ->
    console.log 'start'
    actionCreators.startTableFieldEdit(@props.configurationId, @props.table.get('id'), FIELD)

  _handleEditSave: ->
    actionCreators.saveTableField(
      @props.configurationId,
      @props.table.get('id'),
      FIELD,
      @props.table.getIn(['editingFields', FIELD])
    )


  _handleEditChange: (data) ->
    actionCreators.updateTableFieldEdit(@props.configurationId, @props.table.get('id'), FIELD, data[FIELD])

  render: ->
    modal = React.createElement LoadTypeModal,
      table: @props.table
      onChange: @_handleEditChange
      onSave: @_handleEditSave

    React.createElement ModalTrigger,
      modal: modal
    ,
      React.DOM.span
        className: 'label label-default'
        onClick: @_handleEditStart
      ,
        'Load: '
        @_loadTypeLabel()

  _loadTypeLabel: ->
    switch @props.table.getIn ['data', 'incrementalLoad']
      when false then 'Full'
      when 1 then 'Incremental  1 day'
      else "Incremental  #{@props.table.getIn ['data', 'incrementalLoad']} days"

