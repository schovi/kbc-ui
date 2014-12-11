React = require 'react'
List = require('immutable').List

JobTasks = React.createFactory(require './JobTasks.coffee')
Duration = React.createFactory(require '../../../../react/common/Duration.coffee')
JobStatusLabel = React.createFactory(require('../../../../react/common/common.coffee').JobStatusLabel)

date = require '../../../../utils/date.coffee'
{div, h2, small, span} = React.DOM

JobDetailOverview = React.createClass
  displayName: 'JobDetailBody'
  render: ->
    div null,
      div null,
        div className: 'row',
          div className: 'col-md-6',
            span null, 'Created '
            span null, date.format(@props.job.get('createdTime'))
          div className: 'col-md-6',
            span null, 'Status'
            JobStatusLabel status: @props.job.get('status')
        div className: 'row',
          div className: 'col-md-6',
            span null, 'Start '
            span null, date.format(@props.job.get('startTime'))
          div className: 'col-md-6',
            span null, 'End '
            span null, @props.job.get('endTime')
        div className: 'row',
          div className: 'col-md-6',
            span null, 'Initialized '
            span null, "#{@props.job.get('initializedBy')} (#{@props.job.getIn(['initiatorToken', 'description'])})"
          div className: 'col-md-6',
            span null, 'Token '
            span null, @props.job.getIn(['token', 'description'])

      h2 null,
        'Tasks',
        ' ',
        @_renderTotalDurationInHeader(),
      JobTasks(tasks: @props.job.getIn ['results', 'tasks'], List())

  _renderTotalDurationInHeader: ->
    return '' if !@props.job.get('startTime')
    small null,
      'Total Duration ',
      Duration
        startTime: @props.job.get('startTime')
        endTime: @props.job.get('endTime')


module.exports = JobDetailOverview