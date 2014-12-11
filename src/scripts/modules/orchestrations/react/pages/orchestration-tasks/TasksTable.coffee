React = require 'react'

{table, thead, tbody, th, td, tr} = React.DOM

TasksTable = React.createClass
  displayName: 'TasksTable'
  propTypes:
    tasks: React.PropTypes.object.isRequired

  render: ->
    table className: 'table table-stripped',
      thead null,
        tr null,
          th null, 'Component'
          th null, 'Action'
          th null, 'Parameters'
          th null, 'Active'
          th null, 'Continue on failure'
      tbody null,
        tr null


module.exports = TasksTable



