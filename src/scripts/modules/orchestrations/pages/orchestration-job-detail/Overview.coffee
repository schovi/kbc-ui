React = require 'react'
List = require('immutable').List

JobTasks = React.createFactory(require './JobTasks.coffee')
Duration = React.createFactory(require '../../../../components/common/Duration.coffee')

{div, h2, small} = React.DOM

JobDetailOverview = React.createClass
  displayName: 'JobDetailBody'
  render: ->
    div null,
      @props.job.get('id'),
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