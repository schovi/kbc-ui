React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
goodDataWriterStore = require '../../store'
RoutesStore = require '../../../../stores/RoutesStore'

{ButtonGroup, Button, DropdownButton, MenuItem} = require 'react-bootstrap'

{button, span} = React.DOM

OrchestrationDetailButtons = React.createClass
  displayName: 'GoodDataWriterTableButtons'
  mixins: [createStoreMixin(goodDataWriterStore)]


  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('table')

    table: goodDataWriterStore.getTable(configId, tableId)
    configurationId: configId

  render: ->
    React.createElement ButtonGroup, null,
      React.createElement DropdownButton, null,
        React.createElement MenuItem, null,
          'Reset export status'
        React.createElement MenuItem, null,
          'Reset table'
      React.createElement Button, null,
        span className: 'fa fa-tasks fa-fw'
      React.createElement Button, null,
        span ClassName: 'fa fa-upload fa-fw'
        ' Upload table'


module.exports = OrchestrationDetailButtons
