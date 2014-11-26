React = require 'react'
JobRow = React.createFactory(require './TableRow.coffee')

{table, thead, th, tr, tbody, div} = React.DOM

JobsTable = React.createClass(
  displayName: 'JobsTable'
  propTypes:
    jobs: React.PropTypes.array.isRequired
  cancelJob: (job) ->
    # TODO

  render: ->
    rows = @props.jobs.map (job) ->
      JobRow {job: job, key: job.id, onJobCancel: @cancelJob}
    , @

    jobsTable = (table {className: 'table table-striped kb-table-jobs'},
      (thead {},
        (tr {},
          (th {}, "ID"),
          (th {}, "Status"),
          (th {}, "Created time"),
          (th {}, "Initialized"),
          (th {}, "Creator"),
          (th {}, "Duration"),
          (th {}, null)
        )
      ),
      (tbody {}, rows)
    )

    (div {},
      (jobsTable)
    )

)

module.exports = JobsTable