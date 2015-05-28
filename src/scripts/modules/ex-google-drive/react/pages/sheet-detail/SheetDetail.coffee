React = require('react')
ExGdriveStore = require '../../../exGdriveStore'
ActionCreators = require '../../../exGdriveActionCreators'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
Input = React.createFactory(require('react-bootstrap').Input)
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)

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
    #console.log @state.validation
    #console.log @state.sheet.toJS()
    div {className: 'container-fluid kbc-main-content'},
      form className: 'form-horizontal',
        div className: 'row',
          @_createInput 'Document Title', 'title', 'static'
          @_createInput 'Sheet Title', 'sheetTitle', 'static'
          @_createInput 'Document GoogleId', 'googleId', 'static'
          @_createInput 'Sheet Id', 'sheetId', 'static'
          @_createConfigInput(
            'Output Table'
            =>
              @_parsedConfig()?.db?.table #readFn
            (event, config) -> #setFn
              if not config
                config = {}
              if not config.db
                config.db = {}

              config.db.table = event.target.value
              config
            'text'
            'table'

          )
          @_createConfigInput(
            'Header starts at row'
            (=> @_parsedConfig()?.header?.rows) #readFn
            (event, config) -> #setFn
              if isFinite(event.target.value) and event.target.value != ""
                newRows = parseInt event.target.value
                if not config
                  config = {}
                if not config.header
                  config.header = {}
                config.header.rows = newRows
              return config
            'number'
            'header'
          )
          @_createConfigInput(
            'Raw Config'
            (=> @state.sheet.get 'config') #readFn
            (event, config) ->
              event.target.value
            'textarea'
            'config'
            false
          )



  _handleChange: (propName, event) ->
    ActionCreators.sheetEditOnChange(@state.configId, @state.fileId,  @state.sheetId, propName, event.target.value)

  _parsedConfig: ->
    try
      return JSON.parse(@state.sheet.get 'config')
    catch
      return {}


  _createConfigInput: (caption, readFn, setFn, type, validationProperty,  stringify = true) ->
    if @state.isEditing
      Input
        label: caption
        type: type
        value: readFn()
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
        help: @state.validation?[validationProperty] if @state.isEditing
        bsStyle: 'error' if @state.validation?[validationProperty] and @state.isEditing
        onChange: (event) =>
          config = @_parsedConfig()
          config = setFn(event, config)
          if stringify
            newConfig = JSON.stringify(config)
          else
            newConfig = config
          ActionCreators.sheetEditOnChange(@state.configId, @state.fileId, @state.sheetId, 'config', newConfig)
    else
      StaticText
        label: caption
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      , readFn()




  _createInput: (labelValue, propName, type = 'text') ->
    if type != 'static'
      Input
        label: labelValue
        type: type
        value: @state.sheet.get propName
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
        onChange: @_handleChange.bind @, propName
    else
      StaticText
        label: labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      , @state.sheet.get propName
