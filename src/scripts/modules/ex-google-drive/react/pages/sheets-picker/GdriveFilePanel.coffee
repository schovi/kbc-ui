React = require('react')
ActionCreators = require '../../../exGdriveActionCreators'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
{Panel, PanelGroup, ListGroup, ListGroupItem} = require('react-bootstrap')

#Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup
ListGroup = React.createFactory ListGroup
ListGroupItem = React.createFactory ListGroupItem

{div, span} = React.DOM
Loader = React.createFactory(require('kbc-react-components').Loader)

module.exports = React.createClass
  displayName: 'GdriveFilePanel'
  mixins: [ImmutableRenderMixin]
  propTypes:
    files: React.PropTypes.object
    loadingFiles: React.PropTypes.object
    loadSheetsFn: React.PropTypes.func
    setExpandedSheetsFn: React.PropTypes.func
    expandedSheets: React.PropTypes.object
    isExpandedFn: React.PropTypes.func
    selectSheetFn: React.PropTypes.func
    selectedSheets: React.PropTypes.object
    configuredSheets: React.PropTypes.object
    deselectSheetFn: React.PropTypes.func


  render: ->
    #PanelGroup accordion: true,
    div className: 'kbc-accordion kbc-panel-heading-with-table kbc-panel-heading-with-table'
    ,
      if @props.files and @props.files.count() > 0
        @props.files.map( (file) ->
          @_renderFilePanel(file)
        ,@).toArray()
      else
        div className: 'well', 'No files.'

  _renderFilePanel: (file) ->
    header = div
      onClick: => @_onClick(file)
      file.get 'title'
      ' '
      Loader() if @_isLoading file
    header = div null, 'slect me'
    header = span null,
      span className: 'table',
        span className: 'tbody',
          span className: 'tr',
            span className: 'td',
              file.get 'title'
              ' '
              Loader() if @_isLoading file

    React.createElement Panel,
      onSelect: @_onClick.bind(@, file)
      expanded: @_isExpanded(file)
      key: file.get 'id'
      eventKey: file.get 'id'
      collapsible: true
      header: header

    ,
      if @_isLoading(file)
        div className: 'well',
          'Loading sheets..'
      else
        @_renderSheetsList(file)

  _renderSheetsList: (file) ->
    sheets = file.get 'sheets'
    if sheets
      div className: 'row',
        ListGroup {},
          sheets.map((sheet) =>
            @_renderSheetGroupItem(file, sheet)).toArray()
    else
      div className: 'well', 'No sheets.'

  _renderSheetGroupItem: (file, sheet) ->
    ListGroupItem
      active: @_isSelected(file.get('id'), sheet.get 'id')
      disabled: @_isConfigured(file.get('id'), sheet.get 'id')
      onClick: =>
        if not @_isConfigured(file.get('id'), sheet.get 'id')
          @_sheetOnClick(file, sheet)
      ,
        sheet.get 'title'

  _sheetOnClick: (file, sheet) ->
    fileId = file.get 'id'
    sheetId = sheet.get 'id'
    if @_isSelected(fileId, sheetId)
      @props.deselectSheetFn(fileId, sheetId)
    else
      @props.selectSheetFn(file, sheet)

  _isSelected: (fileId, sheetId) ->
    @props.selectedSheets and @props.selectedSheets.hasIn [fileId, sheetId]

  _isConfigured: (fileId, sheetId) ->
    result = @props.configuredSheets and @props.configuredSheets.find( (sheet) ->
      return sheet.get('sheetId') == sheetId.toString() and sheet.get('googleId') == fileId
    )
    return result

  _isExpanded: (file) ->
    if not @_isLoaded(file)
      return false
    expanded = @props.expandedSheets.get(file.get('id'), true)
    return expanded


  _onClick: (file, e) ->
    e.preventDefault()
    e.stopPropagation()
    if @_isLoaded(file)
      expanded = !!@props.expandedSheets.get(file.get('id'), true)
      newValue = !expanded
      newSheets = @props.expandedSheets.set(file.get('id'), newValue)
      @props.setExpandedSheetsFn(newSheets)
    if not @_isLoading(file) and not @_isLoaded(file)
      @props.loadSheetsFn(file)

  _isLoading: (file) ->
    @props.loadingFiles and @props.loadingFiles.has file.get('id')

  _isLoaded: (file) ->
    @props.files and @props.files.hasIn [file.get('id'),'sheets']
