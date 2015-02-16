React = require('react')
ActionCreators = require '../../../exGdriveActionCreators'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
{Panel, PanelGroup, ListGroup, ListGroupItem} = require('react-bootstrap')

Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup
ListGroup = React.createFactory ListGroup
ListGroupItem = React.createFactory ListGroupItem
Button = React.createFactory(require('react-bootstrap').Button)

{div, span, h3} = React.DOM

module.exports = React.createClass
  displayName: 'ConfigSheetsPanel'
  mixins: [ImmutableRenderMixin]
  propTypes:
    isFileOwnerFn: React.PropTypes.func
    deselectSheetFn: React.PropTypes.func
    selectedSheets: React.PropTypes.object
    configSheets: React.PropTypes.object
    getPathFn: React.PropTypes.func

  render: ->
    #console.log @props.configSheets.toJS()
    div {},
      if @props.configSheets and @props.configSheets.count() > 0
        @_renderConfiguredSheets()
      @_renderSelectedSheets()

  _renderConfiguredSheets: ->
    Panel
      header:
        h3 className: 'text-center', 'Sheets Already Configured in Project'
      ,
        if @props.configSheets
          ListGroup {},
            @props.configSheets.map((sheet) =>
              path = @props.getPathFn(sheet.get('googleId'))
              fileTitle = sheet.get 'title'
              sheetTitle = sheet.get 'sheetTitle'
              ListGroupItem
                className: 'text-center'
                key: sheet.get('sheetId') + sheet.get('googleId')
                ,
                  "#{path} / #{fileTitle} / #{sheetTitle}").toArray()
        else
          div className: 'well', 'No sheets configured in project.'


  _renderSelectedSheets: ->
    #console.log @props.selectedSheets.toJS() if @props.selectedSheets
    Panel
      header:
        h3 className: 'text-center', 'Sheets To Be Added To Project'
      ,
        if @props.selectedSheets
          @_renderSelectedSheetsListGroup()
        else
          div className: 'well', 'No sheets selected.'

  _renderSelectedSheetsListGroup: ->
    listItems = @props.selectedSheets.map((sheets, fileId) =>
      path = @props.getPathFn(fileId)
      sheetItems = sheets.map((sheet, sheetId) =>
        fileTitle = sheet.getIn ['file','title']
        sheetTitle = sheet.get 'title'
        @_renderSheetGroupItem(path, fileTitle, sheetTitle, fileId, sheetId)
        ).toList()
      return sheetItems
    ).toList()
    listItems = listItems.flatten(true).toArray()
    ListGroup {}, listItems


  _renderSheetGroupItem: (path, fileTitle, sheetTitle, fileId, sheetId) ->
    ListGroupItem
      className: 'text-center'
      active: true
      ,
        span {},
          "#{path} / #{fileTitle} / #{sheetTitle}"
          span
            onClick: =>
              @props.deselectSheetFn(fileId, sheetId)
            className: 'btn btn-sm', '×'
