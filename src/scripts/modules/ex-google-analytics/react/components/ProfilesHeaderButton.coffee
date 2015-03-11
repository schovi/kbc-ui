React = require 'react'
Navigation = require('react-router').Navigation
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ExGanalStore = require '../../exGanalStore'
RoutesStore = require '../../../../stores/RoutesStore'
ExGanalActionCreators = require '../../exGanalActionCreators'

Loader = React.createFactory(require '../../../../react/common/Loader')

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'ProfilesHeaderButton'
  mixins: [createStoreMixin(ExGanalStore), Navigation]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    currentConfigId: configId
    isSaving:  ExGanalStore.isSavingProfiles configId


  _handleCancel: ->
    ExGanalActionCreators.cancelSelectedProfiles @state.currentConfigId
    @transitionTo 'ex-google-analytics', config: @state.currentConfigId

  _handleCreate: ->
    component = @
    ExGanalActionCreators
    .saveSelectedProfiles @state.currentConfigId
    .then ->
      component.transitionTo 'ex-google-analytics', config: component.state.currentConfigId

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
        disabled: @state.isSaving
      ,
        'Save'
