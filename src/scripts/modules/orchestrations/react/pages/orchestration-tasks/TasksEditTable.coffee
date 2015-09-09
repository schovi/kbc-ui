React = require 'react'
TasksEditTableRow = React.createFactory(require './TasksEditTableRow')

{table, thead, tbody, th, td, tr} = React.DOM


TasksEditTable = React.createClass
  displayName: 'TasksEditTable'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    components: React.PropTypes.object.isRequired
    disabled: React.PropTypes.bool.isRequired
    onTaskDelete: React.PropTypes.func.isRequired
    onTaskUpdate: React.PropTypes.func.isRequired
    onTaskMove: React.PropTypes.func.isRequired

  render: ->
    table className: 'table table-stripped kbc-table-layout-fixed',
      thead null,
        tr null,
          th style: {width: '5%'},
          th style: {width: '26%'}, 'Component'
          th style: {width: '10%'}, 'Action'
          th style: {width: '28%'}, 'Parameters'
          th style: {width: '8%'}, 'Active'
          th style: {width: '10%'}, 'Continue on Failure'
          th style: {width: '5%'}
      tbody null,
        if @props.tasks.count()
          @props.tasks.map((task) ->
            TasksEditTableRow
              task: task
              component: @props.components.get(task.get('component'))
              disabled: @props.disabled
              key: task.get('id')
              onTaskDelete: @props.onTaskDelete
              onTaskUpdate: @props.onTaskUpdate
              onTaskMove: @props.onTaskMove
          , @).toArray()
        else
          tr null,
            td
              className: 'text-muted'
              colSpan: 8
            ,
              'There are no tasks assigned yet. Please start by adding first task.'


module.exports = TasksEditTable



