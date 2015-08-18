React = require 'react'
{table, tr, th, tbody, thead, div, td} = React.DOM
ColumnDataPreview = React.createFactory(require './ColumnDataPreview')

module.exports = React.createClass
  displayName: 'columnRow'
  propTypes:
    column: React.PropTypes.object
    tdeType: React.PropTypes.object
    editing: React.PropTypes.object
    dataPreview: React.PropTypes.array

  render: ->
    tr null,
      td null, @props.column
      td null, @props.tdeType.get('type')
      td null,
        ColumnDataPreview
          columnName: @props.column
          tableData: @props.dataPreview
