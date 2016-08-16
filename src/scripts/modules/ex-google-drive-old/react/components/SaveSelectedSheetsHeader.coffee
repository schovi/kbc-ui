React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ExGdriveStore = require '../../exGdriveStore'
RoutesStore = require '../../../../stores/RoutesStore'
ExGdriveActionCreators = require '../../exGdriveActionCreators'

Loader = React.createFactory(require('kbc-react-components').Loader)

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'SaveSelectedSheetsHeader'
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
      if @state.isSelected
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
