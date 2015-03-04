React = require 'react'

InlineEditText = React.createFactory(require '../../../../../react/common/InlineEditTextInput')
actionCreators = require '../../../actionCreators'

FIELD = 'name'

module.exports = React.createClass
  displayName: 'TableGdName'

  _handleEditStart: ->
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
    console.log 'rnd', @props.table.toJS()
    isEditing = @props.table.hasIn ['editingFields', FIELD]
    isSaving = @props.table.get('savingFields').contains FIELD
    console.log 'saving', isSaving
    text = if isEditing then @props.table.getIn(['editingFields', FIELD]) else @props.table.getIn(['data', FIELD])
    InlineEditText
      text: text
      placeholder: 'Describe the component ...'
      isSaving: isSaving
      isEditing: isEditing
      isValid: true
      onEditStart: @_handleEditStart
      onEditCancel: @_handleEditCancel
      onEditChange: @_handleEditChange
      onEditSubmit: @_handleEditSave