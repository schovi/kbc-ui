React = require 'react'
createStoreMixin = require('../../../../react/mixins/createStoreMixin')
ComponentsStore = require '../../../components/stores/ComponentsStore'
TaskSelectTableRow = React.createFactory(require './TaskSelectTableRow')


{span} = React.DOM
{input} = React.DOM
{table, thead, tbody} = React.DOM
{th, td, tr} = React.DOM

module.exports = React.createClass
  displayName: 'TaskSelectTable'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    onTaskUpdate: React.PropTypes.func.isRequired

  getInitialState: ->
    components: ComponentsStore.getAll()

  render: ->
    tasks = @props.tasks
    table className: 'table table-stripped kbc-table-layout-fixed',
      thead null,
        tr null,
          th null, 'Component'
          th style: {width: '22%'}, 'Action'
          th style: {width: '30%'}, 'Parameters'
          th style: {width: '8%'}, 'Active'
      tbody null,
        if tasks.count()
          tasks.map((task) ->
            TaskSelectTableRow
              task: task
              component: @state.components.get(task.get('component'))
              onTaskUpdate: @props.onTaskUpdate
          , @).toArray()
        else
          tr null,
            td
              colSpan: 4
              className: 'text-muted'
            ,
              'There are no tasks assigned yet.'