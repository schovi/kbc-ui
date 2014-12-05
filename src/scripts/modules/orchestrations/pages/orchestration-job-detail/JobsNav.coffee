React = require 'react'
_ = require 'underscore'

Router = require 'react-router'

JobStatusCircle = React.createFactory(require '../../../../components/common/JobStatusCircle.coffee')
FinishedWithIcon = React.createFactory(require '../../../../components/common/FinishedWithIcon.coffee')
DurationWithIcon = React.createFactory(require '../../../../components/common/DurationWithIcon.coffee')

Link = React.createFactory(Router.Link)

{div, span, a, em, strong} = React.DOM

JobRow = React.createClass(
  displayName: 'JobsTableRow'
  mixins: [Router.State]
  propTypes:
    job: React.PropTypes.object

  render: ->
    isActive = @isActive('orchestrationJob', {orchestrationId: @getParams().orchestrationId, jobId: @props.job.get('id')})
    className = if  isActive then 'active' else ''

    (Link {className: "list-group-item #{className}", to: 'orchestrationJob', params: {orchestrationId: @getParams().orchestrationId, jobId: @props.job.get('id')}},
      (span {className: 'table'},
        (span {className: 'tr'},
          (span {className: 'td kbc-td-status'},
            (JobStatusCircle {status: @props.job.get('status')})
          ),
          (span {className: 'td'},
            (em {title: @props.job.getIn(['initiatorToken', 'description'])}, 'manually') if @props.job.get('initializedBy') == 'manually',
            (strong null, @props.job.get('id')),
            (span null, (DurationWithIcon {startTime: @props.job.get('startTime'), endTime: @props.job.get('endTime')}) if @props.job.get('startTime')),
            (span {className: 'kb-info clearfix pull-right'},
              (FinishedWithIcon endTime: @props.job.get('endTime'))
            )
          )
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

    (div className: 'kb-orchestrations-nav list-group',
      rows
    )

)

module.exports = JobsNav