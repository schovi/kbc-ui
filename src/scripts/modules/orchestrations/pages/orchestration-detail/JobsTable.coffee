React = require 'react'
JobsTableRow = React.createFactory(require './JobsTableRow.coffee')
RefreshIcon = React.createFactory(require '../../../../components/common/RefreshIcon.coffee')

{table, thead, th, tr, tbody, div} = React.DOM

JobsTable = React.createClass(
  displayName: 'JobsTable'
  propTypes:
    jobs: React.PropTypes.object.isRequired
    jobsLoading: React.PropTypes.bool.isRequired
    onJobsReload: React.PropTypes.func.isRequired

  cancelJob: (job) ->
    # TODO

  render: ->
    rows = @props.jobs.map((job) ->
      JobsTableRow {job: job, key: job.get('id'), onJobCancel: @cancelJob}
    , @).toArray()

    jobsTable = (table {className: 'table table-striped kb-table-jobs'},
      (thead {},
        (tr {},
          (th {}, "ID"),
          (th {}, "Status"),
          (th {}, "Created time"),
          (th {}, "Initialized"),
          (th {}, "Creator"),
          (th {}, "Duration"),
          (th {className: 'text-right'},
            RefreshIcon(
              isLoading: @props.jobsLoading
              onClick: @props.onJobsReload
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