React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
Input = React.createFactory(require('react-bootstrap').Input)
Check = React.createFactory(require('kbc-react-components').Check)
NewDimensionForm = React.createFactory(require './../../components/NewDimensionForm')

{TabbedArea, TabPane} = require 'react-bootstrap'
actionCreators = require '../../../actionCreators'
dateDimensionStore = require '../../../dateDimensionsStore'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'




{div, p, strong, form, input, label, table, tbody, thead, tr, th, td, div} = React.DOM

module.exports = React.createClass
  displayName: 'DateDimensionSelectModal'
  mixins: [createStoreMixin(dateDimensionStore)]
  propTypes:
    configurationId: React.PropTypes.string.isRequired
    column: React.PropTypes.object.isRequired
    onSelect: React.PropTypes.func.isRequired

  componentDidMount: ->
    actionCreators.loadDateDimensions(@props.configurationId)


  getStateFromStores: ->
    isLoading: dateDimensionStore.isLoading(@props.configurationId)
    dimensions: dateDimensionStore.getAll(@props.configurationId)
    isCreatingNewDimension: dateDimensionStore.isCreatingNewDimension(@props.configurationId)
    newDimension: dateDimensionStore.getNewDimension(@props.configurationId)

  _handleNewDimensionSave: ->
    actionCreators
    .saveNewDateDimension(@props.configurationId)
    .then (dateDimension) =>
      @props.onRequestHide()
      @props.onSelect
        selectedDimension: dateDimension.get('name')

  _handleNewDimensionUpdate: (newDimension) ->
    actionCreators.updateNewDateDimension(@props.configurationId, newDimension)

  render: ->
    Modal
      title: @_title()
      onRequestHide: @props.onRequestHide
      bsSize: 'large'
    ,
      div className: 'modal-body',
        React.createElement TabbedArea, null,
          React.createElement TabPane,
            eventKey: 'select'
            tab: 'Select from existing'
          ,
            if @state.isLoading
              p className: 'panel-body',
                'Loading ...'
            else
              @_renderTable()
          React.createElement TabPane,
            eventKey: 'new'
            tab: 'Create new'
          ,
            NewDimensionForm
              isPending: @state.isCreatingNewDimension
              dimension: @state.newDimension
              onChange: @_handleNewDimensionUpdate
              onSubmit: @_handleNewDimensionSave
              buttonLabel: 'Create and select'
      div className: 'modal-footer',
        ButtonToolbar null,
          Button
            onClick: @props.onRequestHide
            bsStyle: 'link'
          ,
            'Close'

  _handleSelectedDimensionChange: (e) ->
    @props.onRequestHide()
    @props.onSelect
      selectedDimension: e.target.value

  _renderTable: ->
    if @state.dimensions.count()
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
                input
                  type: 'radio'
                  checked: dimension.get('id') == @props.column.get('dateDimension')
                  value: dimension.get('id')
                  onChange: @_handleSelectedDimensionChange
          , @
          .toArray()
    else
      p className: 'panel-body',
        'There are no date dimensions yet. Please create new one.'

  _title: ->
    "Date dimension for column #{@props.column.get('name')}"

