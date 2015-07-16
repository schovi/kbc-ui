React = require 'react'
{table, tr, th, tbody, thead, div, td} = React.DOM

module.exports = React.createClass

  displayName: 'ColumnsEditor'
  propTypes:
    columns: React.PropTypes.object
    renderRowFn: React.PropTypes.func

  render: ->
    rows = @props.columns.map((column) =>
      @props.renderRowFn(column)
      )

    div style: {overflow: 'scroll'},
      table className: 'table table-striped kbc-table-editor',
        thead null,
          tr null,
            th null, 'KB Storage Column'
            th null, 'Database Column Name'
            th null, 'Data Type'
            th null
        tbody null,
          rows
