React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
Input = React.createFactory(require('react-bootstrap').Input)
Check = React.createFactory(require('../../../../../react/common/Check'))
NewDimensionForm = React.createFactory(require './../../components/NewDimensionForm')


actionCreators = require '../../../actionCreators'
dateDimensionStore = require '../../../dateDimensionsStore'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'




{div, p, strong, form, input, label, table, tbody, thead, tr, th, td} = React.DOM

module.exports = React.createClass
  displayName: 'DateDimensionSelectModal'
  mixins: [createStoreMixin(dateDimensionStore)]
  propTypes:
    configurationId: React.PropTypes.string.isRequired
    column: React.PropTypes.object.isRequired
    onSelect: React.PropTypes.func.isRequired


  componentDidMount: ->
    actionCreators.loadDateDimensions(@props.configurationId)

  getInitialState: ->
    selectedDimension: @props.column.getIn ['data', 'dateDimension']

  getStateFromStores: ->
    isLoading: dateDimensionStore.isLoading(@props.configurationId)
    dimensions: dateDimensionStore.getAll(@props.configurationId)
    isCreatingNewDimension: dateDimensionStore.isCreatingNewDimension(@props.configurationId)
    newDimension: dateDimensionStore.getNewDimension(@props.configurationId)

  _handleNewDimensionSave: ->
    actionCreators.saveNewDateDimension(@props.configurationId)

  _handleNewDimensionUpdate: (newDimension) ->
    actionCreators.updateNewDateDimension(@props.configurationId, newDimension)

  _handleConfirm: ->
    @props.onRequestHide()
    @props.onSelect
      selectedDimension: @state.selectedDimension

  render: ->
    console.log 'render', @state
    Modal
      title: @_title()
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        'loading' if @state.isLoading
        @_renderTable() if @state.dimensions
        NewDimensionForm
          isPending: @state.isCreatingNewDimension
          dimension: @state.newDimension
          onChange: @_handleNewDimensionUpdate
          onSubmit: @_handleNewDimensionSave
      div className: 'modal-footer',
        ButtonToolbar null,
          Button
            onClick: @props.onRequestHide
            bsStyle: 'link'
          ,
            'Cancel'
          Button
            onClick: @_handleConfirm
            bsStyle: 'success'
          ,
            'Choose'

  _handleSelectedDimensionChange: (e) ->
    @setState
      selectedDimension: e.target.value

  _renderTable: ->
    console.log 'dims', @state.dimensions.toJS()
    table className: 'table table-striped',
      thead null,
        tr null,
          th null, 'Name'
          th null, 'Include time'
          th null, 'Selected'
      tbody null,
        @state.dimensions.map (dimension) ->
          tr
            key: dimension.get 'id'
          ,
            td null,
              dimension.getIn ['data', 'name']
            td null,
              Check
                isChecked: dimension.getIn ['data', 'includeTime']
            td null,
              Input
                type: 'radio'
                checked: dimension.get('id') == @state.selectedDimension
                value: dimension.get('id')
                onChange: @_handleSelectedDimensionChange
        , @
        .toArray()

  _title: ->
    "Date dimension for column #{@props.column.get('name')}"

