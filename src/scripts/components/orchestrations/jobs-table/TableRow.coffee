
React = require 'react'
Router = require 'react-router'

Duration = React.createFactory(require '../../common/Duration.coffee')
JobStatusLabel = React.createFactory(require '../../common/JobStatusLabel.coffee')

{tr, td, div} = React.DOM

JobRow = React.createClass(
  displayName: 'JobRow'
  mixins: [Router.Navigation, Router.State]
  propTypes:
    job: React.PropTypes.object.isRequired
    onJobCancel: React.PropTypes.func

  jobDetail: ->
    # method provided by Router.Navigation mixin
    @transitionTo 'orchestrationJob',
      orchestrationId: @getParams().orchestrationId # current orchestration id
      jobId: @props.job.id

    event.stopPropagation()

  cancelJob: (event) ->
    event.stopPropagation()
    this.props.onJobCancel(@props.job)

  render: ->

    actionButtons = []
    # TODO cancel button

    (tr {onClick: @jobDetail},
      (td {}, @props.job.id),
      (td {}, JobStatusLabel({status: @props.job.status})),
      (td {}, @props.job.createdTime),
      (td {}, @props.job.initializedBy),
      (td {}, @props.job.initiatorToken.description),
      (td {}, (Duration {startTime: @props.job.startTime, endTime: @props.job.endTime})),
      (td {}, (div {className: 'pull-right'}, actionButtons))
    )
)


module.exports = JobRow