React = require 'react'
_ = require 'underscore'
moment = require 'moment'
StatusLabel = React.createFactory require '../../../../../react/common/JobStatusLabel'
Immutable = require 'immutable'

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
{div, strong, span} = React.DOM
Duration = require('../../../../../utils/duration')
date = require '../../../../../utils/date'
{Tree} = require 'kbc-react-components'

module.exports = React.createClass
  displayName: 'GoodDataResultStats'
  mixins: [ImmutableRenderMixin]

  propTypes:
    tasks: React.PropTypes.array.isRequired

  render: ->
    console.log "TASKS", @props.tasks
    div className: 'table table-striped table-hover',
      div className: 'thead', key: 'table-header',
        div className: 'tr',
          span className: 'th',
            strong null, 'Task Id'
          span className: 'th',
            strong null, 'Task Name'
          span className: 'th',
            strong null, 'Started'
          span className: 'th',
            strong null, 'Duration'
          span className: 'th',
            strong null, 'Status'
          span className: 'th',
            strong null, 'Params'
          span className: 'th'
      div className: 'tbody',
          _.map @props.tasks, (task, taskId) =>
            started = "N/A"
            duration = "N/A"
            status = "N/A"
            params = Immutable.fromJS task.params
            if task.event
              duration = task.event.performance.duration
              finished = moment(task.created)
              started = finished.subtract(duration, 'seconds') #TODO
              status = StatusLabel({status: task.event?.type})
              started = date.format(started.toISOString())
            div className: 'tr',
              @_renderCell(taskId.toString())
              @_renderCell(task.name)
              @_renderCell(started)
              @_renderCell(Duration(duration))
              @_renderCell(status)
              @_renderCell(React.createElement Tree, {data: params})


  _renderCell: (value) ->
    div className: 'td',
      value or "N/A"
