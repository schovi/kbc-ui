React = require 'react'
_ = require 'underscore'
{fromJS} = require 'immutable'
{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{button, option, span, i, button, strong, div, input} = React.DOM
Link = React.createFactory(require('react-router').Link)
Input = React.createFactory(require('react-bootstrap').Input)
Loader = React.createFactory(require('kbc-react-components').Loader)
Button = React.createFactory(require('react-bootstrap').Button)
Picker = React.createFactory(require('../../../../google-utils/react/GooglePicker'))
ViewTemplates = require '../../../../google-utils/react/PickerViewTemplates'

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))


module.exports = React.createClass
  displayName: 'WrGdriveTableRow'
  mixins: [ImmutableRenderMixin]

  propTypes:
    isTableExported: React.PropTypes.bool.isRequired
    isPending: React.PropTypes.bool.isRequired
    onExportChangeFn: React.PropTypes.func.isRequired
    table: React.PropTypes.object.isRequired
    file: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired
    folderNames: React.PropTypes.object.isRequired
    editData: React.PropTypes.object.isRequired
    isSaving: React.PropTypes.bool
    editFn: React.PropTypes.func.isRequired
    saveFn: React.PropTypes.func.isRequired
    deleteRowFn: React.PropTypes.func.isRequired


  render: ->
    console.log 'TABLE ROW', @props.table.get('id'), @props
    if !!@props.editData
      return @_renderEditFile()
    if not @props.file
      return @_renderEmptyFile()
    return @_renderStaticFile()


  _renderStaticFile: ->
    div className: 'tr',
      span className: 'td',
        @props.table.get 'name'
      span className: 'td',
        i className: 'fa fa-fw fa-long-arrow-right'
      span className: 'td',
        @props.file.get 'title'
      span className: 'td',
        @props.file.get 'operation'
      span className: 'td',
        @props.file.get 'type'
      span className: 'td',
        @_renderTargetfolder()
      if @props.isSaving
        span className: 'td',
          Loader()
      else
        span className: 'td text-right kbc-no-wrap',
          button
            className: 'btn btn-link'
            onClick: =>
              @props.editFn(@props.file)
          ,
            i className: 'fa fa-fw fa-gear'
          React.createElement Confirm,
            key: @props.table.get 'id'
            title: 'Remove table configuration.'
            text: 'You are about to remove table from the writer configuration.'
            buttonLabel: 'Remove'
            onConfirm: =>
              rowId = @props.file.get('id')
              console.log 'delete row id', rowId
              @props.deleteRowFn(rowId)
          ,
            button className: 'btn btn-link',
              i className: 'kbc-icon-cup'


  _renderEditFile: ->
    buttonSize = 'xsmall'
    div className: 'tr',
      span className: 'td',
        @props.table.get 'name'
      span className: 'td',
        i className: 'fa fa-fw fa-long-arrow-right'
      span className: 'td',
        input
          value: @props.editData?.get 'title'
          type: 'text'
          onChange: (event) =>
            data = event.target.value
            editData = @props.editData.set 'title', data
            @props.editFn(editData)

      span className: 'td',
        @_renderSelect(['update', 'create'], 'operation')
      span className: 'td',
        @_renderSelect(['sheet', 'file'], 'type')
      span className: 'td',
        @_renderPicker()
      span className: 'td',
        if @props.isSaving
          Loader()
        else
          div className: 'form-group',
            div className: 'col-xs-12',
              Button
                bsStyle: 'success'
                bsSize: buttonSize
                disabled: false
                onClick: @_startSaving
              ,
                'Save'
              Button
                bsStyle: 'default'
                bsSize: buttonSize
                disabled: false
                onClick: @_cancel
              ,
                'cancel'

  _cancel: ->
    @props.editFn(null)

  _startSaving: ->
    @props.saveFn(@props.editData).then =>
      @props.editFn(null)

  _renderPicker: ->
    file = @props.editData
    folderId = file.get 'targetFolder'
    folderName = @props.folderNames?.get(folderId).get 'title' if folderId
    Picker
      #email: @state.config.get('email')
      dialogTitle: 'Select a folder'
      buttonLabel: folderName or '/'
      onPickedFn: (data) =>
        data = _.filter data, (file) ->
          file.type == 'folder'
        console.log "PICKED folder", data
        folderId = data[0].id
        folderName = data[0].name
        data[0].title = folderName
        @props.updateGoogleFolderFn(data[0], folderId)
        data = @props.editData.set('targetFolder', folderId)
        @props.editFn(data)
      buttonProps:
        bsStyle: 'default'
        bsSize: 'small'
      views: [
        ViewTemplates.rootFolder
        ViewTemplates.flatFolders
        ViewTemplates.recentFolders
      ]


  _renderEmptyFile: ->
    tableId = @props.table.get 'id'
    tableName = @props.table.get 'name'
    emptyFile =
      title: tableName
      tableId: tableId
      operation: 'update'
      type: 'sheet'
    div className: 'tr',
      span className: 'td', @props.table.get 'name'
      span className: 'td', ''
      span className: 'td', ''
      span className: 'td', ''
      span className: 'td', ''
      span className: 'td', ''
      span className: 'td',
        button
          className: 'btn btn-link'
          onClick: =>
            @props.editFn(fromJS(emptyFile))
        ,
          i className: 'fa fa-fw fa-plus'



  _renderSelect: (options, prop) ->
    return Input

      type: 'select'
      value: @props.editData?.get(prop) or options[0]
      onChange: (e) =>
        value = e.target.value
        data = @props.editData.set(prop, value)
        @props.editFn(data)
    ,
      _.map(options, (label) ->

        option
          value: label
          key: label
        ,
          label
        )




  _renderTargetfolder: ->
    folderId = @props.file.get('targetFolder')
    if not folderId
      return '/'
    else
      folderName = @props.folderNames?.get(folderId)
      console.log folderName?.toJS(),folderId
      if not folderName
        return Loader()
      else
        return folderName.get 'title'
