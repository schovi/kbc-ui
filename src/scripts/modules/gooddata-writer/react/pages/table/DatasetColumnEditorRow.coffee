React = require 'react'
Immutable = require 'immutable'
keyMirror = require('react/lib/keyMirror')

{tr, td, option} = React.DOM

Input = React.createFactory(require('react-bootstrap').Input)

pureRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

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
  mixins: [pureRendererMixin]
  propTypes:
    column: React.PropTypes.object.isRequired
    referenceableColumns: React.PropTypes.object.isRequired
    sortLabelColumns: React.PropTypes.object.isRequired
    isEditing: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func.isRequired

  _handleInputChange: (propName, e) ->
    @props.onChange @props.column.set(propName, e.target.value)

  render: ->
    column = @props.column
    tr null,
      td null,
        column.get('name'),
      td null,
        Input
          type: if @props.isEditing then 'text' else 'static'
          value: column.get 'gdName'
          disabled: !@props.isEditing
          onChange: @_handleInputChange.bind @, 'gdName'
      td null,
        Input
          type: if @props.isEditing then 'select' else 'static'
          value: column.get 'type'
          onChange: @_handleInputChange.bind @, 'type'
        ,
          Immutable.fromJS(ColumnTypes).map (columnType) ->
            option
              value: columnType
              key: columnType
            ,
              columnType
          .toArray()
      td null,
        @_renderSchemaReferenceSelect()
        @_renderReferenceSelect()
      td null,
        @_renderSortLabelSelect()
      td null,
        @_renderDataTypeSelect()
      td null

  _renderSchemaReferenceSelect: ->
    if @_shouldRenderPart visibleParts.SCHEMA_REFERENCE
      Input
        type: if @props.isEditing then 'select' else 'static'
        value: @props.column.get 'schemaReference'
        onChange: @_handleInputChange.bind @, 'schemaReference'

  _renderReferenceSelect: ->
    if @_shouldRenderPart visibleParts.REFERENCE
      Input
        type: if @props.isEditing then 'select' else 'static'
        value: @props.column.get 'reference'
        onChange: @_handleInputChange.bind @, 'reference'
      ,
        @props.referenceableColumns.map (column) ->
          option
            value: column.get('name')
            key: column.get('name')
          ,
            column.get('name')
        .toArray()

  _renderSortLabelSelect: ->
    return if !@_shouldRenderPart visibleParts.SORT_LABEL
    return if !@props.sortLabelColumns.count()
    Input
      type: if @props.isEditing then 'select' else 'static'
      value: @props.column.get 'sortLabel'
      onChange: @_handleInputChange.bind @, 'sortLabel'
    ,
      @props.sortLabelColumns.map (column) ->
        option
          value: column.get('name')
          key: column.get('name')
        ,
          column.get('name')
      .toArray()

  _renderDataTypeSelect: ->
    if @_shouldRenderPart visibleParts.DATA_TYPE
      Input
        type: if @props.isEditing then 'select' else 'static'
        value: @props.column.get 'dataType'
        onChange: @_handleInputChange.bind @, 'dataType'
      ,
        Immutable.fromJS(DataTypes).map (dataType) ->
          option
            key: dataType
            value: dataType
          ,
            dataType
        .toArray()


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

