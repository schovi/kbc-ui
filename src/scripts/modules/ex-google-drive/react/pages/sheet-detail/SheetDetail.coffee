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
    validation: ExGdriveStore.getSheetValidation(config, fileId, sheetId)

  render: ->
    console.log @state.validation
    #console.log @state.sheet.toJS()
    div {className: 'container-fluid'},
      form className: 'form-horizontal',
        div className: 'row',
          @_createInput 'Document Title', 'title', 'static'
          @_createInput 'Sheet Title', 'sheetTitle', 'static'
          @_createInput 'Document GoogleId', 'googleId', 'static'
          @_createInput 'Sheet Id', 'sheetId', 'static'
          @_createConfigInput(
            'SAPI Table'
            =>
              @_parsedConfig()?.db?.table #readFn
            (event, config) -> #setFn
              config?.db?.table = event.target.value
              config
            'text'
          )
          @_createConfigInput(
            'Header starts at row'
            (=> @_parsedConfig()?.header?.rows) #readFn
            (event, config) -> #setFn
              newRows = parseInt event.target.value
              if newRows != NaN or event.target.value == ""
                config?.header?.rows = newRows
              config
            'number'
          )
          @_createConfigInput(
            'Raw Config'
            (=> @state.sheet.get 'config') #readFn
            (event, config) ->
              event.target.value
            'textarea'
            false
          )



  _handleChange: (propName, event) ->
    ActionCreators.sheetEditOnChange(@state.configId, @state.fileId,  @state.sheetId, propName, event.target.value)

  _parsedConfig: ->
    try
      return JSON.parse(@state.sheet.get 'config')
    catch
      return {}


  _createConfigInput: (caption, readFn, setFn, type, stringify = true) ->
    Input
      label: caption
      type: if @state.isEditing then type else 'static'
      value: readFn()
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      onChange: (event) =>
        config = @_parsedConfig()
        config = setFn(event, config)
        if stringify
          newConfig = JSON.stringify(config)
        else
          newConfig = config

        ActionCreators.sheetEditOnChange(@state.configId, @state.fileId, @state.sheetId, 'config', newConfig)



  _createInput: (labelValue, propName, type = 'text') ->
    Input
      label: labelValue
      type: type
      value: @state.sheet.get propName
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      onChange: @_handleChange.bind @, propName
