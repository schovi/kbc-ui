React = require 'react'
_ = require 'underscore'

Router = require 'react-router'

JobStatusCircle = React.createFactory(require '../../../../../react/common/JobStatusCircle.coffee')
FinishedWithIcon = React.createFactory(require '../../../../../react/common/FinishedWithIcon.coffee')
DurationWithIcon = React.createFactory(require '../../../../../react/common/DurationWithIcon.coffee')
ImmutableRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin.coffee'

Link = React.createFactory(Router.Link)

{div, span, a, em, strong} = React.DOM

JobRow = React.createClass(
  displayName: 'JobsTableRow'
  mixins: [ImmutableRendererMixin]
  propTypes:
    job: React.PropTypes.object.isRequired
    isActive: React.PropTypes.bool.isRequired

  render: ->
    className = if  @props.isActive then 'active' else ''

    (Link {className: "list-group-item #{className}", to: 'orchestrationJob', params: {orchestrationId: @props.job.get('orchestrationId'), jobId: @props.job.get('id')}},
      (span {className: 'table'},
        (span {className: 'tr'},
          (span {className: 'td kbc-td-status'},
            (JobStatusCircle {status: @props.job.get('status')})
          ),
          (span {className: 'td'},
            (em {title: @props.job.getIn(['initiatorToken', 'description'])}, 'manually') if @props.job.get('initializedBy') == 'manually'
            (strong null, @props.job.get('id'))
            (span null, (DurationWithIcon {startTime: @props.job.get('startTime'), endTime: @props.job.get('endTime')}) if @props.job.get('startTime'))
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
    activeJobId: React.PropTypes.number
    jobs: React.PropTypes.object

  render: ->
    rows = @props.jobs.map((job) ->
      React.createElement JobRow, {job: job, isActive: @props.activeJobId == job.get('id'), key: job.get('id')}
    , @).toArray()

    (div className: 'kb-orchestrations-nav list-group',
      rows
    )

)

module.exports = JobsNav