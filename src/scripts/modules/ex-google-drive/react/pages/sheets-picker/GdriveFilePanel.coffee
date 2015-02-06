React = require('react')
ActionCreators = require '../../../exGdriveActionCreators.coffee'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin.coffee'
{Panel, PanelGroup, ListGroup, ListGroupItem} = require('react-bootstrap')

Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup
ListGroup = React.createFactory ListGroup
ListGroupItem = React.createFactory ListGroupItem

{div, span} = React.DOM
Loader = React.createFactory(require '../../../../../react/common/Loader.coffee')

module.exports = React.createClass
  displayName: 'GdriveFilePanel'
  mixins: [ImmutableRenderMixin]
  propTypes:
    files: React.PropTypes.object
    loadingFiles: React.PropTypes.object
    loadSheetsFn: React.PropTypes.func
    selectSheetFn: React.PropTypes.func
    selectedSheets: React.PropTypes.object
    deselectSheetFn: React.PropTypes.func


  render: ->
    PanelGroup accordion: true,
      @props.files.map( (file) ->
        @_renderFilePanel(file)
      ,@).toArray()

  _renderFilePanel: (file) ->
    header = div
      className: 'text-center'
      onClick: => @_onClick(file)
      file.get 'title'
      Loader() if @_isLoading file

    Panel
      header: header
      key: file.get 'id'
      eventKey: file.get 'id',
    ,
      if @_isLoading(file)
        div className: 'well',
          'Loading sheets..'
      else
        @_renderSheetsList(file)

  _renderSheetGroupItem: (file, sheet) ->
    ListGroupItem
      className: 'text-center'
      active: @_isSelected(file.get('id'), sheet.get 'id')
      onClick: =>
        @_sheetOnClick(file, sheet)
      ,
        sheet.get 'title'


  _renderSheetsList: (file) ->
    sheets = file.get 'sheets'
    if sheets
      ListGroup {},
        sheets.map((sheet) =>
          @_renderSheetGroupItem(file, sheet)).toArray()

  _sheetOnClick: (file, sheet) ->
    fileId = file.get 'id'
    sheetId = sheet.get 'id'
    if @_isSelected(fileId, sheetId)
      @props.deselectSheetFn(fileId, sheetId)
    else
      @props.selectSheetFn(file, sheet)

  _isSelected: (fileId, sheetId) ->
    @props.selectedSheets and @props.selectedSheets.hasIn [fileId, sheetId]


  _onClick: (file) ->
    if not @_isLoading(file) and not @_isLoaded(file)
      @props.loadSheetsFn(file)

  _isLoading: (file) ->
    @props.loadingFiles and @props.loadingFiles.has file.get('id')

  _isLoaded: (file) ->
    @props.files and @props.files.hasIn [file.get('id'),'sheets']
