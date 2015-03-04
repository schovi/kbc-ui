React = require 'react'
Navigation = require('react-router').Navigation
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ExGanalStore = require '../../exGanalStore'
RoutesStore = require '../../../../stores/RoutesStore'
ExGanalActionCreators = require '../../exGanalActionCreators'

Loader = React.createFactory(require '../../../../react/common/Loader')

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'ExGanalQueryDetailHeaderButtons'
  mixins: [createStoreMixin(ExGanalStore), Navigation]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    name =  RoutesStore.getCurrentRouteParam 'name'
    currentConfigId: configId
    name: name
    configId: configId
    isSaving: ExGanalStore.isSavingQuery configId, name
    isEditing: ExGanalStore.isEditingQuery configId, name
    isInvalid: ExGanalStore.isQueryInvalid configId, name
    query: ExGanalStore.getQuery configId, name

  _handleCancel: ->
    ExGanalActionCreators.resetQuery @state.currentConfigId, @state.name
    @transitionTo 'ex-google-analytics', config: @state.currentConfigId

  _toogleEdit: ->
    ExGanalActionCreators.toogleEditing(@state.configId, @state.name, @state.query)

  _handleCreate: ->
    component = @
    ExGanalActionCreators
    .saveQuery @state.currentConfigId, @state.name
    .then ->
      component.transitionTo 'ex-google-analytics', config: component.state.currentConfigId

  render: ->
    console.log 'is editing', @state.isEditing
    if @state.isEditing
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
          disabled: @state.isSaving or @state.isInvalid
        ,
          'Save'
    else
      React.DOM.div className: 'kbc-buttons',
        button
          className: 'btn btn-success'
          onClick: @_toogleEdit

        ,
          'Edit'
