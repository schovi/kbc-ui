React = require 'react'

InlineEditText = React.createFactory(require '../../../../../react/common/InlineEditTextInput')
actionCreators = require '../../../actionCreators'

module.exports = React.createClass
  displayName: 'TableGdName'
  propTypes:
    table: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired
    fieldName: React.PropTypes.string.isRequired
    placeholder: React.PropTypes.string.isRequired

  getDefaultProps: ->
    fieldName: 'title'

  _handleEditStart: ->
    return if @props.table.getIn ['data', 'isExported']
    actionCreators.startTableFieldEdit(@props.configurationId, @props.table.get('id'), @props.fieldName)

  _handleEditSave: ->
    actionCreators.saveTableField(
      @props.configurationId,
      @props.table.get('id'),
      @props.fieldName,
      @props.table.getIn(['editingFields', @props.fieldName])
    )

  _handleEditCancel: ->
    actionCreators.cancelTableFieldEdit(@props.configurationId, @props.table.get('id'), @props.fieldName)

  _handleEditChange: (column) ->
    actionCreators.updateTableFieldEdit(@props.configurationId, @props.table.get('id'), @props.fieldName, column)

  render: ->
    isEditing = @props.table.hasIn ['editingFields', @props.fieldName]
    isSaving = @props.table.get('savingFields').contains @props.fieldName

    if isEditing
      text = @props.table.getIn(['editingFields', @props.fieldName])
    else
      text = @props.table.getIn(['data', @props.fieldName])

    if @props.table.getIn ['data', 'isExported']
      editTooltip = 'Table cannot be renamed. It is already exported to GoodData'
    else
      editTooltip = 'Edit table name in GoodData'

    InlineEditText
      text: text
      editTooltip: editTooltip
      placeholder: @props.placeholder
      isSaving: isSaving
      isEditing: isEditing
      isValid: true
      onEditStart: @_handleEditStart
      onEditCancel: @_handleEditCancel
      onEditChange: @_handleEditChange
      onEditSubmit: @_handleEditSave
