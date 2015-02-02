React = require('react')
ExGdriveStore = require '../../../exGdriveStore.coffee'
ActionCreators = require '../../../exGdriveActionCreators.coffee'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'
Input = React.createFactory(require('react-bootstrap').Input)


{div, span, form } = React.DOM
module.exports = React.createClass
  displayName: "SheetDetail"
  mixins: [createStoreMixin(ExGdriveStore)]

  getStateFromStores: ->
    sheetId = RoutesStore.getCurrentRouteParam('sheetId')
    fileId = RoutesStore.getCurrentRouteParam('fileId')
    config = RoutesStore.getCurrentRouteParam('config')
    sheet = ExGdriveStore.getConfigSheet(config, fileId, sheetId)
    if ExGdriveStore.isEditingSheet(config, fileId, sheetId)
      sheet = ExGdriveStore.getEditingSheet(config, fileId, sheetId)
    if ExGdriveStore.isSavingSheet(config, fileId, sheetId)
      sheet = ExGdriveStore.getSavingSheet(config, fileId, sheetId)
    sheet: sheet
    isEditing: ExGdriveStore.isEditingSheet(config, fileId, sheetId)
    configId: config
    sheetId: sheetId
    fileId: fileId

  render: ->
    #console.log @state.sheet.toJS()
    div {className: 'container-fluid'},
      form className: 'form-horizontal',
        div className: 'row',
          @_createInput 'Document Title', 'title', 'static'
          @_createInput 'Sheet Title', 'sheetTitle', 'static'
          @_createInput 'Document GoogleId', 'googleId', 'static'
          @_createInput 'Sheet Id', 'sheetId', 'static'
          if @state.isEditing
            @_createInput 'Raw Config', 'config', 'textarea'
          else
            @_createInput 'Raw Config', 'config', 'static'

  _handleChange: (propName, event) ->
    ActionCreators.sheetEditOnChange(@state.configId, @state.fileId,  @state.sheetId, propName, event.target.value)
















  _createInput: (labelValue, propName, type = 'text') ->
    Input
      label: labelValue
      type: type
      value: @state.sheet.get propName
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      onChange: @_handleChange.bind @, propName
