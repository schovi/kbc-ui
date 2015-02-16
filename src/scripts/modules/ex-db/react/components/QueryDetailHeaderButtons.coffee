React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ExDbStore = require '../../exDbStore'
RoutesStore = require '../../../../stores/RoutesStore'
ExDbActionCreators = require '../../exDbActionCreators'
Loader = React.createFactory(require '../../../../react/common/Loader')

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'QueryDetailHeaderButtons'
  mixins: [createStoreMixin(ExDbStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    queryId = RoutesStore.getCurrentRouteIntParam 'query'
    currentConfigId: configId
    currentQueryId: queryId
    isEditing: ExDbStore.isEditingQuery configId, queryId
    isSaving: ExDbStore.isSavingQuery configId, queryId

  _handleEditStart: ->
    ExDbActionCreators.editQuery @state.currentConfigId, @state.currentQueryId

  _handleCancel: ->
    ExDbActionCreators.cancelQueryEdit @state.currentConfigId, @state.currentQueryId

  _handleCreate: ->
    ExDbActionCreators.saveQueryEdit @state.currentConfigId, @state.currentQueryId

  render: ->
    if @state.isEditing
      React.DOM.div className: 'kbc-buttons',
        if @state.isSaving
          Loader()
        button
          className: 'btn btn-link'
          disabled: @state.isSaving
          onClick: @_handleCancel
        ,
          'Cancel'
        button
          className: 'btn btn-success'
          disabled: @state.isSaving
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
          ' Edit query'
