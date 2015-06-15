React = require 'react'

JobRow = require './SidebarJobsRow'
{Loader} = require 'kbc-react-components'
PureRenderMixin = require('react/addons').addons.PureRenderMixin

###
 jobs structure:
  isLoaded
  isLoading
  jobs
###

module.exports = React.createClass
  displayName: 'LatestJobs'
  mixins: [PureRenderMixin]
  propTypes:
    jobs: React.PropTypes.object.isRequired
  render: ->
    React.DOM.div null,
      React.DOM.h4 null,
        'Last runs '
        React.createElement(Loader) if @props.jobs.get 'isLoading'
      React.DOM.div className: 'kbc-sidebar-jobs',
        @props.jobs.get('jobs').map (job) ->
          React.createElement JobRow,
            job: job
            key: job.get 'id'
        .toArray()
