React = require 'react'
TasksTableRow = React.createFactory(require './TasksTableRow')



{table, thead, tbody, th, td, tr} = React.DOM


TasksTable = React.createClass
  displayName: 'TasksTable'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    orchestration: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired
    onRun: React.PropTypes.func.isRequired

  _handleTaskRun: (task) ->
    @props.onRun(task)

  render: ->
    table className: 'table table-stripped kbc-table-layout-fixed',
      thead null,
        tr null,
          th null, 'Component'
          th null, 'Configuration'
          th style: {width: '10%'}, 'Action'
          th null, 'Parameters'
          th style: {width: '8%'}, 'Active'
          th style: {width: '12%'}, 'Continue on Failure'
          th style: {width: '8%'}, ''
      tbody null,
        if @props.tasks.count()
          @props.tasks.map((task) ->
            TasksTableRow
              task: task
              orchestration: @props.orchestration
              component: @props.components.get(task.get('component'))
              key: task.get('id')
              onRun: @_handleTaskRun
          , @).toArray()
        else
          tr null,
            td
              colSpan: 7
              className: 'text-muted'
            ,
              'There are no tasks assigned yet.'


module.exports = TasksTable



