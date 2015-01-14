React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'
ExDbStore = require '../../exDbStore.coffee'
RoutesStore = require '../../../../stores/RoutesStore.coffee'
ExDbActionCreators = require '../../exDbActionCreators.coffee'

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'CredentialsHeaderButtons'
  mixins: [createStoreMixin(ExDbStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    currentConfigId: configId
    isEditing: ExDbStore.isEditingCredentials configId

  _handleEditStart: ->
    ExDbActionCreators.editCredentials @state.currentConfigId

  _handleCancel: ->
    ExDbActionCreators.cancelCredentialsEdit @state.currentConfigId

  _handleCreate: ->
    ExDbActionCreators.saveCredentialsEdit @state.currentConfigId

  render: ->
    if @state.isEditing
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
    else
      React.DOM.div null,
        button
          className: 'btn btn-success'
          onClick: @_handleEditStart
        ,
          span className: 'fa fa-edit'
          ' Edit Credentials'
