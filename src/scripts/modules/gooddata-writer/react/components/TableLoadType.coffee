React = require 'react'
{fromJS} = require 'immutable'
actionCreators = require '../../actionCreators'

{Modal, ModalTrigger, Input, Button, ButtonToolbar} = require 'react-bootstrap'

{strong, a, small, option, select, label, input, div, span} = React.DOM
Loader = React.createFactory(require('kbc-react-components').Loader)
ConfirmButtons = require('../../../../react/common/ConfirmButtons').default


FIELD = 'incrementalLoad'
GRAIN = 'grain'

LoadTypeModal = React.createClass
  displayName: 'LoadTypeModal'
  propTypes:
    columns: React.PropTypes.object.isRequired
    table: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    onChangeGrain: React.PropTypes.func.isRequired
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
    console.log(@props.table?.toJS(), @props.columns?.toJS(), @props.grain)
    isSaving = @props.table.get('savingFields').contains FIELD
    grain = ''
    if @props.table.hasIn(['editingFields', FIELD])
      incrementalLoad = @props.table.getIn ['editingFields', FIELD]
      grain = @props.table.getIn ['editingFields', GRAIN]
    else
      incrementalLoad = @props.table.getIn ['data', FIELD]
      grain = @props.table.getIn ['data', GRAIN]

    numberInput = React.DOM.input
      type: 'number'
      value: parseInt(incrementalLoad)
      onChange: @_handleIncrementalDaysNumber
      className: 'form-control'
      style:
        width: '50px'
        display: 'inline-block'

    incrementalHelp = React.DOM.span null,
      'Data will be apended to dataset. '
      'Only rows created or updated in last '
      numberInput
      ' '
      if incrementalLoad == 1 then 'day' else 'days'
      ' will be uploaded to the dataset.'

    React.createElement Modal,
      title: "Table #{@props.table.getIn ['data', 'title']} Load Type"
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        div className: 'form-horizontal',
          React.createElement Input,
            bsSize: 'small'
            type: 'radio'
            wrapperClassName: 'col-sm-offset-2 col-sm-8'
            help: 'All data in GoodData dataset will be replaced by current data in source Storage API table.'
            label: 'Full Load'
            checked: !incrementalLoad
            onChange: @_handleModeRadioChange.bind @, 'full'
            disabled: isSaving
          div className: 'form-group form-group-sm',
            div className: 'col-sm-offset-2 col-sm-8',
              div className: 'radio',
                label null,
                  input
                    type: 'radio'
                    label: 'Incremental'
                    checked: incrementalLoad > 0
                    onChange: @_handleModeRadioChange.bind @, 'incremental'
                    disabled: isSaving
                  span null, 'Incremental'
              span className: 'help-block',
                incrementalHelp
              @_renderFactGrainSelector(grain or '', incrementalLoad > 0)
      div className: 'modal-footer',
        React.createElement ConfirmButtons,
          isSaving: isSaving
          isDisabled: isSaving
          saveLabel: 'Save'
          onCancel: @props.onRequestHide
          onSave: @props.onSave

  _renderFactGrainSelector: (grain, enabled) ->
    if grain == ''
      grainArray = []
    else
      grainArray = grain.split(',')
    console.log('CURRENT GRAIN', grain)
    div null,
      label null,
        'Fact Grain:'
      div null,
        small null,
          a
            href: 'https://developer.gooddata.com/article/set-fact-table-grain'
            target: '_blank'
            'https://developer.gooddata.com/article/set-fact-table-grain'
      div className: 'col-sm-12',
        grainArray.map( (g) =>
          @_renderOneGrainFactSelect(g, grainArray, enabled)
        )
        if grainArray.length != @props.columns.count()
          @_renderOneGrainFactSelect('', grainArray, enabled)
      if @props.columns.count() == 0
        div className: 'text text-warning',
          strong null, 'Warning: '
          'Violated conditions for fact grain: \
          There must be at least one column of attribute, reference or date type and no connection point.'
  _renderOneGrainFactSelect: (selectedColumn, grainArray, enabled) ->
    columnsOptions = null
    columns = @props.columns
    if (not columns or columns.count() == 0) and selectedColumn != ''
      tmp = {}
      tmp[selectedColumn] = selectedColumn
      columns = fromJS(tmp)
    if columns
      columnsOptions = columns
      .filter((value, key) -> key not in grainArray or key == selectedColumn)
      .map((value, key) ->
        option {key: key, value: key},
          key

        ).toArray()
      columnsOptions = columnsOptions.concat(
        option key: '', value: '', disabled: 'true',
          small null, '- add -'
      )
    span { style: {'padding-left': 0}, className: 'col-sm-4'},
      select
        className: 'form-control'
        disabled: !enabled
        type: 'select'
        value: selectedColumn
        onChange: (e) => @_onChangeGrainColumn(e.target.value, selectedColumn, grainArray)
        columnsOptions
      if selectedColumn != '' and enabled
        span
          className: 'fa fa-fw kbc-icon-cup kbc-cursor-pointer'
          onClick: => @_onRemoveGrainColumn(selectedColumn, grainArray)

  _onRemoveGrainColumn: (col, grainArray) ->
    grainArray = grainArray.filter((g) -> g != col)
    @props.onChangeGrain(grainArray.join(','))

  _onChangeGrainColumn: (newGrain, oldGrain, grainArray) ->
    if oldGrain != ''
      grainArray = grainArray.filter((g) -> g != oldGrain)
    grainArray.push(newGrain)
    @props.onChangeGrain(grainArray.join(','))

module.exports = React.createClass
  displayName: 'TableGdName'
  propTypes:
    columns: React.PropTypes.object.isRequired
    table: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired

  _handleEditStart: ->
    actionCreators.startTableFieldEdit(@props.configurationId, @props.table.get('id'), FIELD)
    actionCreators.startTableFieldEdit(@props.configurationId, @props.table.get('id'), GRAIN)

  _handleEditSave: ->
    fields = {}
    fields[FIELD] = @props.table.getIn(['editingFields', FIELD])
    fields[GRAIN] = @props.table.getIn(['editingFields', GRAIN])

    actionCreators.saveMultipleTableFields(
      @props.configurationId,
      @props.table.get('id'),
      fields
    )

    # actionCreators.saveTableField(
    #   @props.configurationId,
    #   @props.table.get('id'),
    #   FIELD,
    #   @props.table.getIn(['editingFields', FIELD])
    # )

  _handleGrainChange: (newGrain) ->
    actionCreators.updateTableFieldEdit(@props.configurationId, @props.table.get('id'), GRAIN, newGrain)

  _handleEditChange: (data) ->
    actionCreators.updateTableFieldEdit(@props.configurationId, @props.table.get('id'), FIELD, data[FIELD])

  render: ->
    modal = React.createElement LoadTypeModal,
      columns: @props.columns
      table: @props.table
      onChangeGrain: @_handleGrainChange
      onChange: @_handleEditChange
      onSave: @_handleEditSave

    React.createElement ModalTrigger,
      modal: modal
    ,
      React.DOM.button
        className: 'btn label label-default'
        onClick: @_handleEditStart
      ,
        'Load: '
        @_loadTypeLabel()
        ' '
        span className: 'kbc-icon-pencil'

  _loadTypeLabel: ->
    switch @props.table.getIn ['data', 'incrementalLoad']
      when false, 0 then 'Full'
      when 1 then 'Incremental  1 day'
      else "Incremental  #{@props.table.getIn ['data', 'incrementalLoad']} days"
