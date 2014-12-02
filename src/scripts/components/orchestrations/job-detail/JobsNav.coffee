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
    isActive = @isActive('orchestrationJob', {orchestrationId: @getParams().orchestrationId, jobId: @props.job.get('id')})
    className = if  isActive then 'active' else ''

    (Link {className: "list-group-item #{className}", to: 'orchestrationJob', params: {orchestrationId: @getParams().orchestrationId, jobId: @props.job.get('id')}},
      (JobStatusCircle {status: @props.job.get('status')}),
      (span null, @props.job.get('id')),
      (span {className: 'pull-right kb-info', title: @props.job.getIn(['initiatorToken', 'description'])}, 'manually') if @props.job.get('initializedBy') == 'manually'
      (span {className: 'kb-info clearfix'},
        (DurationWithIcon {startTime: @props.job.get('startTime'), endTime: @props.job.get('endTime')}) if @props.job.get('startTime')
        (span {className: 'pull-right'},
          (FinishedWithIcon endTime: @props.job.get('endTime'))
        )
      )
    )
)

JobsNav = React.createClass(
  displayName: 'JobsNav'
  propTypes:
    jobsLoading: React.PropTypes.bool
    jobs: React.PropTypes.object

  render: ->
    rows = @props.jobs.map((job) ->
      React.createElement JobRow, {job: job, key: job.get('id')}
    , @).toArray()

    (div className: 'kb-orchestrations-nav',
      rows
    )

)

module.exports = JobsNav