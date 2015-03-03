React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'

dateDimensionsStore = require '../../../dateDimensionsStore'
actionCreators = require '../../../actionCreators'


DateDimensionsTable = React.createFactory(require './DimensionsTable')
NewDimensionForm = React.createFactory(require './../../components/NewDimensionForm')

{strong, br, ul, li, div, span, i} = React.DOM


module.exports = React.createClass
  displayName: 'DateDimensions'
  mixins: [createStoreMixin(dateDimensionsStore)]

  getStateFromStores: ->
    configurationId = RoutesStore.getCurrentRouteParam('config')
    dimensions: dateDimensionsStore.getAll(configurationId)
    isCreatingNewDimension: dateDimensionsStore.isCreatingNewDimension(configurationId)
    configurationId: configurationId
    newDimension: dateDimensionsStore.getNewDimension(configurationId)

  _handleNewDimensionSave: ->
    actionCreators.saveNewDateDimension(@state.configurationId)

  _handleNewDimensionUpdate: (newDimension) ->
    actionCreators.updateNewDateDimension(@state.configurationId, newDimension)

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'col-sm-8',
        DateDimensionsTable
          dimensions: @state.dimensions
          configurationId: @state.configurationId
      div className: 'col-sm-4',
        NewDimensionForm
          isPending: @state.isCreatingNewDimension
          dimension: @state.newDimension
          onChange: @_handleNewDimensionUpdate
          onSubmit: @_handleNewDimensionSave

