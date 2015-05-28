React = require 'react'
TasksTableRow = React.createFactory(require './TasksTableRow')



{table, thead, tbody, th, td, tr} = React.DOM


TasksTable = React.createClass
  displayName: 'TasksTable'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired

  render: ->
    table className: 'table table-stripped kbc-table-layout-fixed',
      thead null,
        tr null,
          th null, 'Component'
          th style: {width: '10%'}, 'Action'
          th style: {width: '40%'}, 'Parameters'
          th style: {width: '8%'}, 'Active'
          th style: {width: '12%'}, 'Continue on Failure'
      tbody null,
        @props.tasks.map((task) ->
          TasksTableRow
            task: task
            component: @props.components.get(task.get('component'))
            key: task.get('id')
        , @).toArray()


module.exports = TasksTable



