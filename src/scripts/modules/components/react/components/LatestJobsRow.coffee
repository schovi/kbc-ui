React = require 'react'


JobStatusCircle = React.createFactory(require '../../../../react/common/JobStatusCircle')
FinishedWithIcon = React.createFactory(require '../../../../react/common/FinishedWithIcon')
DurationWithIcon = React.createFactory(require '../../../../react/common/DurationWithIcon')
ImmutableRendererMixin = require '../../../../react/mixins/ImmutableRendererMixin'

Link = React.createFactory(require('react-router').Link)

{div, span, a, em, strong} = React.DOM

JobNavRow = React.createClass
  displayName: 'LatestJobsRow'
  mixins: [ImmutableRendererMixin]
  propTypes:
    job: React.PropTypes.object.isRequired

  render: ->
    Link
      className: "list-group-item"
      to: 'jobDetail'
      params:
        jobId: @props.job.get('id')
    ,
     span className: 'table',
      span className: 'tr',
        span className: 'td kbc-td-status',
          JobStatusCircle status: @props.job.get('status')
        span className: 'td',
          strong null,
            @props.job.get('id')
          div null,
            em null, @props.job.getIn ['token', 'description']
          React.DOM.br()
          div null,
            if @props.job.get('startTime')
              DurationWithIcon startTime: @props.job.get('startTime'), endTime: @props.job.get('endTime')
          div null,
            FinishedWithIcon endTime: @props.job.get('endTime')


module.exports = JobNavRow
