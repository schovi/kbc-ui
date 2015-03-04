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
    config = exGanalStore.getConfig(configId)
    configId: configId
    query: exGanalStore.getNewQuery(configId)
    profiles: config.get 'items'
    validation: exGanalStore.getNewQueryValidation(configId)

  render: ->
    if @state.query
      QueryEditor
        configId: @state.configId
        onChange: @_onHandleChange
        query: @state.query
        profiles: @state.profiles
        validation: @state.validation
    else
      div()

  _onHandleChange: (newQuery) ->
    ExGanalActionCreators.changeNewQuery(@state.configId, newQuery)
