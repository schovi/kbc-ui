React = require 'react'
Immutable = require 'immutable'
keyMirror = require('react/lib/keyMirror')

{tr, td, option, span, div} = React.DOM

Input = React.createFactory(require('react-bootstrap').Input)
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
DateDimensionModal = React.createFactory(require './DateDimensionSelectModal')
DateFormatHint = require './DateFormatHint'
PureRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
#PureRenderMixin = require('react/addons').addons.PureRenderMixin


{ColumnTypes, DataTypes, SortOrderOptions} = require '../../../constants'


visibleParts = keyMirror(
  DATA_TYPE: null
  SORT_LABEL: null
  DATE: null
  REFERENCE: null
  SCHEMA_REFERENCE: null
)


module.exports = React.createClass
  displayName: 'DatasetColumnEditorRow'
  mixins: [PureRenderMixin]
  propTypes:
    column: React.PropTypes.object.isRequired
    referenceableColumns: React.PropTypes.object.isRequired
    referenceableTables: React.PropTypes.object.isRequired
    sortLabelColumns: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired
    isEditing: React.PropTypes.bool.isRequired
    isValid: React.PropTypes.bool.isRequired
    isSaving: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func.isRequired

  _handleInputChange: (propName, e) ->
    @props.onChange @props.column.set(propName, e.target.value)

  render: ->
    column = @props.column
    rowClassName = if @props.isValid then '' else 'danger'
    tr className: rowClassName,
      td null,
        column.get('name'),
      td null,
        Input
          type: if @props.isEditing then 'text' else 'static'
          value: column.get 'gdName'
          disabled: @props.isSaving
          onChange: @_handleInputChange.bind @, 'gdName'
      td null,
        Input
          type: if @props.isEditing then 'select' else 'static'
          value: column.get 'type'
          disableD: @props.isSaving
          onChange: @_handleInputChange.bind @, 'type'
        ,
          @_selectOptions Immutable.fromJS(ColumnTypes)

      td null,
        @_renderSchemaReferenceSelect()
        @_renderReferenceSelect()
        @_renderDateSelect()

      td null,
        @_renderSortLabelSelect()
      td null,
        @_renderDataTypeSelect()
      td null

  _renderSchemaReferenceSelect: ->
    if @_shouldRenderPart visibleParts.SCHEMA_REFERENCE
      Input
        type: if @props.isEditing then 'select' else 'static'
        value: @props.column.get 'schemaReference', ''
        disabled: @props.isSaving
        onChange: @_handleInputChange.bind @, 'schemaReference'
      ,
        @_selectOptions(
          @props.referenceableTables
          .set('', '')
        )

  _renderReferenceSelect: ->
    if @_shouldRenderPart visibleParts.REFERENCE
      Input
        type: if @props.isEditing then 'select' else 'static'
        disabled: @props.isSaving
        value: @props.column.get 'reference'
        onChange: @_handleInputChange.bind @, 'reference'
      ,
        @_selectOptions(
          @props.referenceableColumns
          .set('', '')
        )

  _renderSortLabelSelect: ->
    return if !@_shouldRenderPart visibleParts.SORT_LABEL
    return if !@props.sortLabelColumns.count()
    Input
      type: if @props.isEditing then 'select' else 'static'
      value: @props.column.get 'sortLabel'
      disabled: @props.isSaving
      onChange: @_handleInputChange.bind @, 'sortLabel'
    ,
      @_selectOptions(
        @props.sortLabelColumns
        .set('', '')
      )


  _renderDataTypeSelect: ->
    if @_shouldRenderPart visibleParts.DATA_TYPE
      span null,
        Input
          type: if @props.isEditing then 'select' else 'static'
          value: @props.column.get 'dataType'
          disabled: @props.isSaving
          onChange: @_handleInputChange.bind @, 'dataType'
        ,
          @_selectOptions Immutable.fromJS(DataTypes).set('', '')

        if [DataTypes.VARCHAR, DataTypes.DECIMAL].indexOf(@props.column.get 'dataType') >= 0
          Input
            type: if @props.isEditing then 'text' else 'static'
            value: @props.column.get 'dataTypeSize'
            disabled: @props.isSaving
            onChange: @_handleInputChange.bind @, 'dataTypeSize'


  _renderDateSelect: ->
    return if !@_shouldRenderPart visibleParts.DATE
    div null,
      Input
        type: if @props.isEditing then 'text' else 'static'
        value: @props.column.get 'format'
        disabled: @props.isSaving
        onChange: @_handleInputChange.bind @, 'format'
        addonAfter: DateFormatHint() if @props.isEditing
      span null,
        'Date dimension: '
        @props.column.get 'dateDimension'
        ' '
        if @props.isEditing
          ModalTrigger
            modal: DateDimensionModal
              column: @props.column
              configurationId: @props.configurationId
              onSelect: @_handleDateDimensionSelect
          ,
            span className: 'btn btn-link',
              span className: 'fa fa-calendar'
              ' '
              if @props.column.get('dateDimension')
                'Change'
              else
                'Add'

  _handleDateDimensionSelect: (data) ->
    @props.onChange @props.column.set('dateDimension', data.selectedDimension)


  _shouldRenderPart: (partName) ->
    allowedPartsForType = switch @props.column.get 'type'
      when ColumnTypes.ATTRIBUTE then [visibleParts.DATA_TYPE, visibleParts.SORT_LABEL]
      when ColumnTypes.IGNORE then []
      when ColumnTypes.CONNECTION_POINT then [visibleParts.DATA_TYPE, visibleParts.SORT_LABEL]
      when ColumnTypes.DATE then [visibleParts.DATE]
      when ColumnTypes.FACT then [visibleParts.DATA_TYPE]
      when ColumnTypes.HYPERLINK then [visibleParts.REFERENCE]
      when ColumnTypes.LABEL then [visibleParts.REFERENCE, visibleParts.DATA_TYPE]
      when ColumnTypes.REFERENCE then [visibleParts.SCHEMA_REFERENCE]

    allowedPartsForType.indexOf(partName) >= 0

  _selectOptions: (options) ->
    options
    .sort()
    .map (value, key) ->
      option
        key: key
        value: key
      ,
        value
    .toArray()

