React = require 'react'

JobRow = React.createFactory(require './LatestJobsRow')

module.exports = React.createClass
  displayName: 'LatestJobs'
  propTypes:
    jobs: React.PropTypes.object.isRequired
  render: ->
    React.DOM.div null,
      React.DOM.h3 null, 'Last runs'
      React.DOM.div null,
        @props.jobs.map (job) ->
          JobRow job: job
        .toArray()
