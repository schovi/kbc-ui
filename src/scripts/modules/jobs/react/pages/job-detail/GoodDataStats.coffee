React = require 'react'
_ = require 'underscore'
moment = require 'moment'

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
{div, strong, span} = React.DOM
Duration = require('../../../../../utils/duration')

module.exports = React.createClass
  displayName: 'GoodDataResultStats'
  mixins: [ImmutableRenderMixin]

  propTypes:
    tasks: React.PropTypes.array.isRequired
    #events: React.PropTypes.object.isRequired

  render: ->
    console.log "tasks", @props.tasks

    div className: 'table table-striped table-hover',
      div className: 'thead', key: 'table-header',
        div className: 'tr',
          span className: 'th',
            strong null, 'Task Id'
          span className: 'th',
            strong null, 'Task Name'
          span className: 'th',
            strong null, 'Start Time'
          span className: 'th',
            strong null, 'Duration'
          span className: 'th',
            strong null, 'Status'
          span className: 'th'
      div className: 'tbody',
          _.map @props.tasks, (task, taskId) =>
            if task
              duration = task.performance.duration
              m = moment(task.created)
              finished = m.subtract(duration, 'seconds') #TODO
            div className: 'tr',
              @_renderCell(taskId?.toString())
              @_renderCell(task?.task.name)
              @_renderCell(task?.created)
              @_renderCell(Duration(task?.performance.duration))
              @_renderCell(task?.type)


  _renderCell: (value) ->
    div className: 'td',
      value or "N/A"
