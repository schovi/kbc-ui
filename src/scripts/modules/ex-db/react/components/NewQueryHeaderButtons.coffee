React = require 'react'
Navigation = require('react-router').Navigation
createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'
ExDbStore = require '../../exDbStore.coffee'
RoutesStore = require '../../../../stores/RoutesStore.coffee'
ExDbActionCreators = require '../../exDbActionCreators.coffee'

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'NewQueryHeaderButtons'
  mixins: [createStoreMixin(ExDbStore), Navigation]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    currentConfigId: configId

  _handleCancel: ->
    ExDbActionCreators.resetNewQuery @state.currentConfigId
    @transitionTo 'ex-db', config: @state.currentConfigId

  _handleCreate: ->
    component = @

    ExDbActionCreators
    .createQuery @state.currentConfigId
    .then ->
      component.transitionTo 'ex-db', config: component.state.currentConfigId

  render: ->
    React.DOM.div className: 'kbc-buttons',
      button
        className: 'btn btn-link'
        onClick: @_handleCancel
      ,
        'Cancel'
      button
        className: 'btn btn-success'
        onClick: @_handleCreate
      ,
        'Save'

