React = require 'react'
JobsNavRow = React.createFactory(require './JobsNavRow.coffee')

JobsNav = React.createClass
  displayName: 'JobsNav'
  propTypes:
    jobsLoading: React.PropTypes.bool.isRequired
    activeJobId: React.PropTypes.number.isRequired
    jobs: React.PropTypes.object.isRequired

  render: ->
    rows = @props.jobs.map((job) ->
      JobsNavRow
        job: job
        isActive: @props.activeJobId == job.get('id')
        key: job.get('id')
    , @).toArray()

    React.DOM.div className: 'kb-orchestrations-nav list-group',
      rows

module.exports = JobsNav