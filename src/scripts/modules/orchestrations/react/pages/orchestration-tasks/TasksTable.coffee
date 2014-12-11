React = require 'react'
TasksTableRow = React.createFactory(require './TasksTableRow.coffee')



{table, thead, tbody, th, td, tr} = React.DOM


TasksTable = React.createClass
  displayName: 'TasksTable'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired

  render: ->
    console.log 'tasks', @props.tasks.toJS(), @props.components.toJS()
    table className: 'table table-stripped',
      thead null,
        tr null,
          th colSpan: 2, 'Component'
          th null, 'Action'
          th null, 'Parameters'
          th null, 'Active'
          th null, 'Continue on failure'
      tbody null,
        @props.tasks.map((task) ->
          TasksTableRow
            task: task
            component: @props.components.get(task.get('component'))
            key: task.get('id')
        , @).toArray()


module.exports = TasksTable



