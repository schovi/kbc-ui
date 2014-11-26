React = require 'react'
_ = require 'underscore'

Router = require 'react-router'

JobStatusCircle = React.createFactory(require '../../common/JobStatusCircle.coffee')
FinishedWithIcon = React.createFactory(require '../../common/FinishedWithIcon.coffee')
DurationWithIcon = React.createFactory(require '../../common/DurationWithIcon.coffee')

Link = React.createFactory(Router.Link)

{div, span, a} = React.DOM

JobRow = React.createClass(
  displayName: 'JobRow'
  mixins: [Router.State]
  propTypes:
    job: React.PropTypes.object

  render: ->
    isActive = @isActive('orchestrationJob', {orchestrationId: @getParams().orchestrationId, jobId: @props.job.id})
    className = if  isActive then 'active' else ''
    (Link {className: "list-group-item #{className}", to: 'orchestrationJob', params: {orchestrationId: @getParams().orchestrationId, jobId: @props.job.id}},
      (JobStatusCircle {status: @props.job.status}),
      (span null, @props.job.id),
      (span {className: 'pull-right kb-info', title: @props.job.initiatorToken.description}, 'manually') if @props.job.initializedBy == 'manually'
      (span {className: 'kb-info clearfix'},
        (DurationWithIcon {startTime: @props.job.startTime, endTime: @props.job.endTime}) if @props.job.startTime
        (span {className: 'pull-right'},
          (FinishedWithIcon endTime: @props.job.endTime)
        )
      )
    )
)

JobsNav = React.createClass(
  displayName: 'JobsNav'
  propTypes:
    jobsLoading: React.PropTypes.bool
    jobs: React.PropTypes.array

  render: ->
    rows = _.map(@props.jobs, (job) ->
      React.createElement JobRow, {job: job, key: job.id}
    , @)

    (div className: 'kb-orchestrations-nav',
      rows
    )

)

module.exports = JobsNav