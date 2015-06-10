React = require 'react'
JobsTableRow = React.createFactory(require './JobsTableRow')
RefreshIcon = React.createFactory(require('kbc-react-components').RefreshIcon)
ImmutableRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

{table, thead, th, tr, td, tbody, div} = React.DOM

JobsTable = React.createClass(
  displayName: 'JobsTable'
  mixins: [ImmutableRendererMixin]
  propTypes:
    jobs: React.PropTypes.object.isRequired
    jobsLoading: React.PropTypes.bool.isRequired
    onJobsReload: React.PropTypes.func.isRequired

  cancelJob: (job) ->
    # TODO

  render: ->
    if @props.jobs.count()
      rows = @props.jobs.map((job) ->
        JobsTableRow {job: job, key: job.get('id'), onJobCancel: @cancelJob}
      , @).toArray()
    else
      rows = [
        tr null,
          td
            className: 'text-muted'
            colSpan: 7
          ,
            'Orchestration has not been executed yet.'
      ]

    jobsTable = (table {className: 'table table-striped table-hover kb-table-jobs'},
      (thead {},
        (tr {},
          (th {}, "ID"),
          (th {}, "Status"),
          (th {}, "Created time"),
          (th {}, "Initialized"),
          (th {}, "Creator"),
          (th {}, "Duration"),
          (th {className: 'text-right kbc-last-column-header'},
            RefreshIcon(
              isLoading: @props.jobsLoading
              onClick: @props.onJobsReload
              loaderPosition: 'left'
            )
          )
        )
      ),
      (tbody {}, rows)
    )

    (div {},
      (jobsTable)
    )

)

module.exports = JobsTable