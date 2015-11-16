React = require 'react'
_ = require 'underscore'
{fromJS} = require 'immutable'
{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{a, small, button, option, span, i, button, strong, div, input} = React.DOM
Link = React.createFactory(require('react-router').Link)
Input = React.createFactory(require('react-bootstrap').Input)
Loader = React.createFactory(require('kbc-react-components').Loader)

RowEditor = require './RowEditor'

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))
SapiTableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx').default)


tooltips =
  file: 'uploads selected table as csv a file'
  sheet: 'uploads selected table as google drive spreadsheet'
  update: 'always update the same file or sheet, if does not exist create one'
  create: 'always create new file with unique name by appending current date and time to the name.'


module.exports = React.createClass
  displayName: 'WrGdriveTableRow'
  mixins: [ImmutableRenderMixin]

  propTypes:
    table: React.PropTypes.object.isRequired
    file: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired
    email: React.PropTypes.string.isRequired
    googleInfo: React.PropTypes.object.isRequired
    editData: React.PropTypes.object.isRequired
    isSavingFn: React.PropTypes.bool
    editFn: React.PropTypes.func.isRequired
    saveFn: React.PropTypes.func.isRequired
    loadGoogleInfoFn: React.PropTypes.func.isRequired
    deleteRowFn: React.PropTypes.func.isRequired
    isLoadingGoogleInfoFn: React.PropTypes.func.isRequired
    isDeleted: React.PropTypes.bool
    updateGoogleFolderFn: React.PropTypes.func.isRequired



  render: ->
    if !!@props.editData
      return @_renderEditFile()
    if not @props.file
      return @_renderEmptyFile()
    return @_renderStaticFile()

  _renderStaticFile: ->
    div className: 'tr',
      span className: 'td',
        SapiTableLinkEx tableId: @props.table.get('id'),
          @props.table.get 'name'
      span className: 'td',
        i className: 'kbc-icon-arrow-right'
      span className: 'td',
        span null,
          @props.file.get 'title'
          @_renderPreviewLink()
      span className: 'td',
        React.createElement Tooltip,
          tooltip: tooltips[@props.file.get('operation')]
        ,
          span null,
            @props.file.get 'operation'
      span className: 'td',
        React.createElement Tooltip,
          tooltip: tooltips[@props.file.get('type')]
        ,
          span null,
            @props.file.get 'type'

      span className: 'td',
        @_renderTargetfolder()
      if @props.isSavingFn()
        span className: 'td',
          Loader()
      else
        span className: 'td text-right kbc-no-wrap',
          if not @props.isDeleted
            button
              className: 'btn btn-link'
              onClick: =>
                @props.editFn(@props.file)
            ,
              i className: 'fa fa-fw kbc-icon-pencil'
          React.createElement Confirm,
            key: @props.table.get 'id'
            title: 'Remove table configuration.'
            text: 'You are about to remove table from the writer configuration.'
            buttonLabel: 'Remove'
            onConfirm: =>
              rowId = @props.file.get('id')
              @props.deleteRowFn(rowId)
          ,
            button className: 'btn btn-link',
              i className: 'kbc-icon-cup'
          if not @props.isDeleted
            @_renderRunButton()


  _renderEditFile: ->
    return React.createElement RowEditor,
      table: @props.table
      editFn: @props.editFn
      editData: @props.editData
      isSavingFn: @props.isSavingFn
      email: @props.email
      googleInfo: @props.googleInfo
      saveFn: @props.saveFn
      updateGoogleFolderFn: @props.updateGoogleFolderFn

  _renderEmptyFile: ->
    tableId = @props.table.get 'id'
    tableName = @props.table.get 'name'
    emptyFile =
      title: tableName
      tableId: tableId
      operation: 'update'
      type: 'sheet'
    div className: 'tr',
      span className: 'td',
        SapiTableLinkEx tableId: @props.table.get('id'),
          @props.table.get 'name'
      span className: 'td', ''
      span className: 'td', ''
      span className: 'td', ''
      span className: 'td', ''
      span className: 'td', ''
      span className: 'td text-right kbc-no-wrap',
        button
          className: 'btn btn-link'
          onClick: =>
            @props.editFn(fromJS(emptyFile))
        ,
          i className: 'fa fa-fw fa-plus'


  _renderRunButton: ->
    React.createElement Tooltip,
      tooltip: 'Upload table to Google Drive'
    ,
      RunButtonModal
        title: "Upload #{@props.table.get('id')}"
        tooltip: "Upload #{@props.table.get('id')}"
        mode: 'button'
        icon: 'fa fa-upload fa-fw'
        component: 'wr-google-drive'
        runParams: =>
          file: @props.file.get 'id'
          config: @props.configId
      ,
       "You are about to run upload of #{@props.table.get('id')} to Google Drive."

  _renderPreviewLink: ->
    googleId = @props.file?.get 'googleId'
    if not _.isEmpty(googleId)
      googleInfo = @props.googleInfo?.get(googleId)
      if googleInfo
        url = googleInfo.get('alternateLink')
        name = googleInfo.get('title') or googleInfo.get('originalFilename')
        return div null,
          a {href: url, target: '_blank'},
            small null, name
      else
        return div 'kbc-no-wrap pull-right',
          if @props.isLoadingGoogleInfoFn(googleId)
            Loader()
          else
            button
              style:
                padding: '0'
              className: 'btn btn-link btn-sm',
              onClick: =>
                @props.loadGoogleInfoFn(googleId)
              small null,
                'Link To Google Drive'
    else
      return span null, ''



  _renderTargetfolder: ->
    folderId = @props.file.get('targetFolder')
    if not folderId
      return '/'
    else
      folderName = @props.googleInfo?.get(folderId)
      if not folderName
        return Loader()
      else
        return folderName.get 'title'
