React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'
ExDbStore = require '../../exDbStore.coffee'
RoutesStore = require '../../../../stores/RoutesStore.coffee'
Link = React.createFactory(require('react-router').Link)

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'AddQueryButton'
  mixins: [createStoreMixin(ExDbStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    currentConfigId: RoutesStore.getCurrentRouteParam 'config'

  render: ->
    Link
      to: 'ex-db-new-query'
      params:
        config: @state.currentConfigId
      className: 'btn btn-success'
    ,
      span className: 'kbc-icon-plus'
      ' Add Query'