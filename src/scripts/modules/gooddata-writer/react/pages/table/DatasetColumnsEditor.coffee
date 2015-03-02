React = require 'react'

###
  Pravidla:
  * sloupec je nevalidní pokud
   - je LABEL nebo HYPERLINK a nemá nastavenou reference
   - je REFERENCE a nemá nastavený schemaReference
   - gdName je prázdné
   - DATE sloupec nemá dimenzi nebo formát


  * změna typu sloupce
    - pokud na sloupec již není možné referencovat, zrušit reference u všech sloupců které na něj ukazují
    - pokud se změnil na CONNECTION_POINT původní CONNECTION_POINT nastavit na ATTRIBUTE pokud existuje

  * změna reference
    - reset sort label všem sloupcům který na měněný sloupec ukazovali

  * změna schema reference
   - pokud na stejné schéma referencuje nějaký jiný sloupec -> resetnout mu schemaReference


   columnDefaults =
        dataType: null
        dataTypeSize: null
        reference: null
        schemaReference: null
        format: null
        dateDimension: null
        sortLabel: null
        sortOrder: null

      typesConfiguration =
        'ATTRIBUTE':
          displayParts: ['dataType', 'sortLabel']
        'IGNORE':
          displayParts: []
        'CONNECTION_POINT':
          displayParts: ['dataType', 'sortLabel']
        'DATE':
          displayParts: ['date']
        'FACT':
          displayParts: ['dataType']
        'HYPERLINK':
          displayParts: ['reference']
        'LABEL':
          displayParts: ['reference', 'dataType']
        'REFERENCE':
          displayParts: ['schemaReference']

###


{table, tr, th, tbody, thead} = React.DOM

Row = React.createFactory(require './DatasetColumnEditorRow')
pureRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

{ColumnTypes} = require '../../../constants'

module.exports = React.createClass
  displayName: 'DatasetColumnsEditor'
  mixins: [pureRendererMixin]
  propTypes:
    columns: React.PropTypes.object.isRequired
    invalidColumns: React.PropTypes.object.isRequired
    referenceableTables: React.PropTypes.object.isRequired
    isEditing: React.PropTypes.bool.isRequired
    onColumnChange: React.PropTypes.func.isRequired

  _handleColumnChange: (column) ->
    @props.onColumnChange column

  render: ->
    table className: 'table table-striped',
      thead null,
        tr null,
          th null, 'Column'
          th null, 'GoodData name'
          th null, 'Type'
          th null, 'Reference'
          th null, 'Sort Label'
          th null, 'Data Type'
          th null
      tbody null,
        @props.columns.map (currentColumn) ->
          Row
            column: currentColumn
            referenceableTables: @props.referenceableTables
            referenceableColumns: @props.columns.filter (column) ->
              return false if column.get('name') == currentColumn.get('name')
              return true if [ColumnTypes.CONNECTION_POINT, ColumnTypes.ATTRIBUTE].indexOf(column.get('type')) >= 0
              return false
            sortLabelColumns: @props.columns.filter (column) ->
              currentColumn.get('name') == column.get('reference')
            isEditing: @props.isEditing
            isValid: !@props.invalidColumns.contains currentColumn.get('name')
            key: currentColumn.get 'name'
            onChange: @_handleColumnChange
        , @
        .toArray()



