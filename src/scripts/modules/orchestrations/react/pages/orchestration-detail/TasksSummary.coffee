React = require 'react'

ComponentsStore = require '../../../../components/stores/ComponentsStore.coffee'
ComponentName = React.createFactory(require('../../../../../react/common/common.coffee').ComponentName)

module.exports = React.createClass
  displayName: 'TasksSummary'
  propTypes:
    tasks: React.PropTypes.object.isRequired
    tasksCount: React.PropTypes.number

  getDefaultProps: ->
    tasksCount: 3

  getInitialState: ->
    components: ComponentsStore.getAll()

  render: ->
    hasMoreTasks = @props.tasks.size > @props.tasksCount
    React.DOM.span null,
      if @props.tasks.size == 0
        'Orchestration has no assigned tasks'
      else
        React.DOM.span null,
          @props.tasks.take(@props.tasksCount).map( (task, index, tasks) ->
            React.DOM.span key: task.get('id'),
              if @state.components.get(task.get('component'))
                ComponentName component: @state.components.get(task.get('component'))
              else
                React.DOM.span null,
                  if task.get('componentUrl')
                    task.get('componentUrl')
                  else
                    task.get('component')
              ,
              ' and ' if index == tasks.size - 2 && !hasMoreTasks
              ' , ' if index < tasks.size - 2 || (index == tasks.size - 2 && hasMoreTasks)
          , @).toArray()
          " and #{@props.tasks.size - @props.tasksCount} more" if hasMoreTasks