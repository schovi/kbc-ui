React = require 'react'
TasksEditTableRow = React.createFactory(require './TasksEditTableRow.coffee')

{table, thead, tbody, th, td, tr} = React.DOM


TasksEditTable = React.createClass
  displayName: 'TasksEditTable'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired
    onTaskDelete: React.PropTypes.func.isRequired
    onTaskUpdate: React.PropTypes.func.isRequired
    onTaskMove: React.PropTypes.func.isRequired

  render: ->
    table className: 'table table-stripped',
      thead null,
        tr null,
          th colSpan: 3, 'Component'
          th null, 'Action'
          th null, 'Parameters'
          th null, 'Active'
          th null, 'Continue on failure'
          th null
      tbody null,
        @props.tasks.map((task) ->
          TasksEditTableRow
            task: task
            component: @props.components.get(task.get('component'))
            key: task.get('id')
            onTaskDelete: @props.onTaskDelete
            onTaskUpdate: @props.onTaskUpdate
            onTaskMove: @props.onTaskMove
        , @).toArray()


module.exports = TasksEditTable



