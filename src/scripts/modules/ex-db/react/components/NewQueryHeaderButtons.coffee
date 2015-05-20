React = require 'react'
Navigation = require('react-router').Navigation
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ExDbStore = require '../../exDbStore'
RoutesStore = require '../../../../stores/RoutesStore'
ExDbActionCreators = require '../../exDbActionCreators'

Loader = React.createFactory(require('kbc-react-components').Loader)

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'NewQueryHeaderButtons'
  mixins: [createStoreMixin(ExDbStore), Navigation]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    currentConfigId: configId
    isSaving: ExDbStore.isSavingNewQuery configId
    isValid: ExDbStore.isValidNewQuery configId

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
      if @state.isSaving
        Loader()
      button
        className: 'btn btn-link'
        onClick: @_handleCancel
        disabled: @state.isSaving
      ,
        'Cancel'
      button
        className: 'btn btn-success'
        onClick: @_handleCreate
        disabled: @state.isSaving || !@state.isValid
      ,
        'Save'

