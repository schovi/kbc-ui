React = require 'react'

InlineEditText = React.createFactory(require '../../../../../react/common/InlineEditTextInput')
actionCreators = require '../../../actionCreators'

FIELD = 'title'

module.exports = React.createClass
  displayName: 'TableGdName'

  _handleEditStart: ->
    return if @props.table.getIn ['data', 'isExported']
    actionCreators.startTableFieldEdit(@props.configurationId, @props.table.get('id'), FIELD)

  _handleEditSave: ->
    actionCreators.saveTableField(
      @props.configurationId,
      @props.table.get('id'),
      FIELD,
      @props.table.getIn(['editingFields', FIELD])
    )

  _handleEditCancel: ->
    actionCreators.cancelTableFieldEdit(@props.configurationId, @props.table.get('id'), FIELD)

  _handleEditChange: (column) ->
    actionCreators.updateTableFieldEdit(@props.configurationId, @props.table.get('id'), FIELD, column)

  render: ->
    isEditing = @props.table.hasIn ['editingFields', FIELD]
    isSaving = @props.table.get('savingFields').contains FIELD
    text = if isEditing then @props.table.getIn(['editingFields', FIELD]) else @props.table.getIn(['data', FIELD])
    if @props.table.getIn ['data', 'isExported']
      editTooltip = 'Table cannot be renamed. It is already exported to GoodData'
    else
      editTooltip = 'Edit table name in GoodData'

    InlineEditText
      text: text
      editTooltip: editTooltip
      placeholder: 'Table Name'
      isSaving: isSaving
      isEditing: isEditing
      isValid: true
      onEditStart: @_handleEditStart
      onEditCancel: @_handleEditCancel
      onEditChange: @_handleEditChange
      onEditSubmit: @_handleEditSave
