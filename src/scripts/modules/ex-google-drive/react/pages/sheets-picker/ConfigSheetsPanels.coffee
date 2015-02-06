React = require('react')
ActionCreators = require '../../../exGdriveActionCreators.coffee'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin.coffee'
{Panel, PanelGroup, ListGroup, ListGroupItem} = require('react-bootstrap')

Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup
ListGroup = React.createFactory ListGroup
ListGroupItem = React.createFactory ListGroupItem

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
      @_renderConfiguredSheets()
      @_renderSelectedSheets()

  _renderSelectedSheets: ->
    console.log @props.selectedSheets.toJS() if @props.selectedSheets
    # Panel
    #   header:
    #     h3 className:'text-center', 'Sheets To Be Added To Project'
    #   ,
    #     if @props.selectedSheets
    #       ListGroup {},
    #         @props.selectedSheets.forEach((sheets, fileId) =>
    #           path = @props.getPathFn(fileId)
    #           sheets.map (sheet) ->
    #             fileTitle = sheet.getIn ['file','title']
    #             sheetTitle = sheet.get 'title'
    #             ListGroupItem
    #               className: 'text-center'
    #               active: true
    #             ,
    #                "#{path} / #{fileTitle} / #{sheetTitle}").toArray()

  _renderConfiguredSheets: ->
    Panel
      header:
        h3 className: 'text-center', 'Sheets Already Configured in Project'
      ,
        ListGroup {},
          @props.configSheets.map((sheet) =>
            path = @props.getPathFn(sheet.get('googleId'))
            fileTitle = sheet.get 'title'
            sheetTitle = sheet.get 'sheetTitle'
            ListGroupItem
              className: 'text-center'
              ,
                "#{path} / #{fileTitle} / #{sheetTitle}").toArray()
