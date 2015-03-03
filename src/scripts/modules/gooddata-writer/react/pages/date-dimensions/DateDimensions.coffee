React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'

dateDimensionsStore = require '../../../dateDimensionsStore'
actionCreators = require '../../../actionCreators'

DateDimensionsTable = React.createFactory(require './DimensionsTable')

{strong, br, ul, li, div, span, i} = React.DOM


module.exports = React.createClass
  displayName: 'DateDimensions'
  mixins: [createStoreMixin(dateDimensionsStore)]

  getStateFromStores: ->
    configurationId = RoutesStore.getCurrentRouteParam('config')
    dimensions: dateDimensionsStore.getAll(configurationId)
    configurationId: configurationId


  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'col-sm-8',
        DateDimensionsTable
          dimensions: @state.dimensions
          configurationId: @state.configurationId
