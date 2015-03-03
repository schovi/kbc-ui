React = require('react')
exGanalStore = require('../../../exGanalStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGanalActionCreators  = require '../../../exGanalActionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'
QueryEditor = React.createFactory(require '../../components/QueryEditor')

module.exports = React.createClass
  displayName: 'ExGanalNewQuery'
  mixins: [createStoreMixin(exGanalStore)]

  getStateFromStores: ->
    configId = RoutesStore.getRouterState().getIn ['params', 'config']
    configId: configId
    query: exGanalStore.getNewQuery(configId)

  render: ->
    QueryEditor
      configId: @state.configId
      onChange: @_onHandleChange
      query: @state.query


  _onHandleChange: (newQuery) ->
    ExGanalActionCreators.changeNewQuery(@state.configId, newQuery)
