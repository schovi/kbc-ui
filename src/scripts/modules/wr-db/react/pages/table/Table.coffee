React = require 'react'

{fromJS, Map, List} = require('immutable')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

WrDbStore = require '../../../store'
WrDbActions = require '../../../actionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'

componentId = 'wr-db'
driver = 'mysql'

{p, ul, li, span, button, strong, div, i} = React.DOM

module.exports = React.createClass
  displayName: "WrDbTableDetail"
  mixins: [createStoreMixin(WrDbStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('tableId')
    columns = WrDbStore.getColumns(driver, configId, tableId)

    columns: columns.get('columns')

  render: ->
    console.log 'render columns', @state.columns.toJS()
    div null, 'tableDetail'
