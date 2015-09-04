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




{div, p, strong, form, input, label, table, tbody, thead, tr, th, td, div, a} = React.DOM

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

  _selectDimension: (id) ->
    @props.onRequestHide()
    @props.onSelect
      selectedDimension: id

  _renderTable: ->
    if @state.dimensions.count()
      div className: 'table table-striped table-hover',
        div className: 'thead',
          div className: 'tr',
            div className: 'th', 'Name'
            div className: 'th', 'Include time'
            div className: 'th', 'Selected'
        div className: 'tbody',
          @state.dimensions.map (dimension) ->
            a
              className: 'tr'
              key: dimension.get 'id'
              onClick: @_selectDimension.bind @, dimension.get('id')
            ,
              div className: 'td',
                dimension.getIn ['data', 'name']
              div className: 'td',
                Check
                  isChecked: dimension.getIn ['data', 'includeTime']
              div className: 'td',
                if dimension.get('id') == @props.column.get('dateDimension')
                  Check
                    isChecked: true
          , @
          .toArray()
    else
      p className: 'panel-body',
        'There are no date dimensions yet. Please create new one.'

  _title: ->
    "Date dimension for column #{@props.column.get('name')}"

