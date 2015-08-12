React = require 'react'
_ = require 'underscore'

storageTablesStore = require '../../../../components/stores/StorageTablesStore'
storageActionCreators = require '../../../../components/StorageActionCreators'

Picker = React.createFactory(require('../../../../google-utils/react/GooglePicker'))
ViewTemplates = require '../../../../google-utils/react/PickerViewTemplates'

{a, small, button, option, span, i, button, strong, div, input} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)
Loader = React.createFactory(require('kbc-react-components').Loader)

tooltips =
  file: 'uploads selected table as csv a file'
  sheet: 'uploads selected table as google drive spreadsheet'
  update: 'always update the same file or sheet, if does not exist create one'
  create: 'always create new file with unique name by appending current date and time to the name.'


module.exports = React.createClass
  displayName: 'RowEditor'
  propTypes:
    editFn: React.PropTypes.func.isRequired
    table: React.PropTypes.object
    editData: React.PropTypes.object.isRequired
    isSaving: React.PropTypes.bool
    email: React.PropTypes.string.isRequired
    googleInfo: React.PropTypes.object.isRequired
    saveFn: React.PropTypes.func.isRequired

  getStateFromStores: ->
    isTablesLoading = storageTablesStore.getIsLoading()
    tables = storageTablesStore.getAll()

    #state
    isTablesLoading: isTablesLoading
    tables: tables


  render: ->
    buttonSize = 'xsmall'
    div className: 'tr',
      span className: 'td',
        @props.table.get 'name'
      span className: 'td',
        i className: 'kbc-icon-arrow-right'
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

      if @props.isSaving
        span className: 'td text-right kbc-no-wrap',
          Loader()
      else
        span className: 'td text-right kbc-no-wrap',
            button
              className: 'btn btn-success btn-sm'
              onClick: @_startSaving
            ,
              'Save'
            button
              className: 'btn btn-link btn-sm'
              onClick: @_cancel
            ,
              'Cancel'
  _cancel: ->
    @props.editFn(null)


  _startSaving: ->
    @props.saveFn(@props.editData).then =>
      @props.editFn(null)

  _renderPicker: ->
    file = @props.editData
    folderId = file.get 'targetFolder'
    folderName = @props.googleInfo?.get(folderId).get 'title' if folderId
    Picker
      email: @props.email
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

  _renderSelect: (options, prop) ->
    return Input
      bsSize: "small"
      type: 'select'
      value: @props.editData?.get(prop) or options[0]
      onChange: (e) =>
        value = e.target.value
        data = @props.editData.set(prop, value)
        @props.editFn(data)
    ,
      _.map(options, (label) ->
        option
          title: tooltips[label]
          value: label
          key: label
        ,
          label
        )
