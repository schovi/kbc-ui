React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'
ExDbStore = require '../../exDbStore.coffee'
RoutesStore = require '../../../../stores/RoutesStore.coffee'
ExDbActionCreators = require '../../exDbActionCreators.coffee'

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'AddQueryButton'
  mixins: [createStoreMixin(ExDbStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    currentConfigId: RoutesStore.getCurrentRouteParam 'config'

  _handleQueryCreate: ->
    ExDbActionCreators.createQuery @state.currentConfigId

  render: ->
    button
      className: 'btn btn-success'
      onClick: @_handleQueryCreate
    ,
      span className: 'kbc-icon-plus'
      ' Add Query'