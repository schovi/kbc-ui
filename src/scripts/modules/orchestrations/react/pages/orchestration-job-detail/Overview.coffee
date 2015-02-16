React = require 'react'
List = require('immutable').List

JobTasks = React.createFactory(require './JobTasks')
Duration = React.createFactory(require '../../../../../react/common/Duration')
JobStatusLabel = React.createFactory(require('../../../../../react/common/common').JobStatusLabel)

date = require '../../../../../utils/date'
{div, h2, small, span, strong} = React.DOM

JobDetailOverview = React.createClass
  displayName: 'JobDetailBody'
  render: ->
    div null,
      div className: 'table kbc-table-border-vertical kbc-detail-table',
        div className: 'tr',
          div className: 'td',
            div className: 'row',
              span className: 'col-md-3', 'Created '
              strong className: 'col-md-9', date.format(@props.job.get('createdTime'))
            div className: 'row',
              span className: 'col-md-3', 'Start '
              strong className: 'col-md-9', date.format(@props.job.get('startTime'))
            div className: 'row',
              span className: 'col-md-3', 'Initialized '
              strong
                className: 'col-md-9',
                "#{@props.job.get('initializedBy')} (#{@props.job.getIn(['initiatorToken', 'description'])})"
          div className: 'td',
            div className: 'row',
              span className: 'col-md-3', 'Status '
              span className: 'col-md-9', JobStatusLabel status: @props.job.get('status')
            div className: 'row',
              span className: 'col-md-3', 'End '
              strong className: 'col-md-9', @props.job.get('endTime')
            div className: 'row',
              span className: 'col-md-3', 'Token '
              strong className: 'col-md-9', @props.job.getIn(['token', 'description'])

      h2 null,
        'Tasks',
        ' ',
        @_renderTotalDurationInHeader(),
      JobTasks(tasks: @props.job.getIn ['results', 'tasks'], List())

  _renderTotalDurationInHeader: ->
    return '' if !@props.job.get('startTime')
    small className: 'pull-right',
      'Total Duration ',
      Duration
        startTime: @props.job.get('startTime')
        endTime: @props.job.get('endTime')


module.exports = JobDetailOverview
