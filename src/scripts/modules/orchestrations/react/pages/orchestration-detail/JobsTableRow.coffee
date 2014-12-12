
React = require 'react'
Router = require 'react-router'

Link = React.createFactory(Router.Link)
Duration = React.createFactory(require '../../../../../react/common/Duration.coffee')
JobStatusLabel = React.createFactory(require '../../../../../react/common/JobStatusLabel.coffee')
date = require '../../../../../utils/date.coffee'

ImmutableRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin.coffee'

{tr, td, div, span} = React.DOM

JobRow = React.createClass(
  displayName: 'JobsTableRow'
  mixins: [Router.Navigation, Router.State]
  propTypes:
    job: React.PropTypes.object.isRequired
    onJobCancel: React.PropTypes.func

  jobDetail: ->
    # method provided by Router.Navigation mixin
    @transitionTo 'orchestrationJob',
      orchestrationId: @getParams().orchestrationId # current orchestration id
      jobId: @props.job.get('id')

    event.stopPropagation()

  cancelJob: (event) ->
    event.stopPropagation()
    this.props.onJobCancel(@props.job)

  render: ->
    console.log 'render', @props.job.get('id')

    actionButtons = []
    actionButtons.push(Link
        key: 'detail'
        to: 'orchestrationJob'
        params:
          orchestrationId: @getParams().orchestrationId
          jobId: @props.job.get('id')
        className: 'btn kbc-btn-link-icon'
        onClick: (e) ->
          e.stopPropagation()
      ,
        span className: 'fa fa-bars'
    )

    (tr {onClick: @jobDetail},
      (td {}, @props.job.get('id')),
      (td {}, JobStatusLabel({status: @props.job.get('status')})),
      (td {}, date.format(@props.job.get('createdTime'))),
      (td {}, @props.job.get('initializedBy')),
      (td {}, @props.job.getIn(['initiatorToken', 'description'])),
      (td {}, (Duration
        startTime: @props.job.get('startTime')
        endTime: @props.job.get('endTime')
      )),
      (td {}, (div {className: 'pull-right'}, actionButtons))
    )
)


module.exports = JobRow