React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'
ExGdriveStore = require '../../exGdriveStore.coffee'
RoutesStore = require '../../../../stores/RoutesStore.coffee'
ExGdriveActionCreators = require '../../exGdriveActionCreators.coffee'

Loader = React.createFactory(require '../../../../react/common/Loader.coffee')

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'SaveSelectedSheetsHeader.coffee'
  mixins: [createStoreMixin(ExGdriveStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    selectedSheets = ExGdriveStore.getSelectedSheets(configId)
    configId: configId
    isSelected: selectedSheets and selectedSheets.count() > 0
    selectedSheets: selectedSheets
    isSaving: ExGdriveStore.isSavingNewSheets(configId)


  _handleCancel: ->
    ExGdriveActionCreators.cancelSheetSelection(@state.configId)

  _handleSave: ->
    ExGdriveActionCreators.saveSheetsSelection(@state.configId)


  render: ->
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
        disabled: @state.isSaving or not @state.isSelected
        onClick: @_handleSave
      ,
        'Save'
