React = require 'react'

JobRow = require './SidebarJobsRow'
{Loader} = require 'kbc-react-components'
{Link} = require('react-router')
PureRenderMixin = require('react/addons').addons.PureRenderMixin
{div, small} = React.DOM

require('./SidebarJobs.less')

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
    limit: React.PropTypes.number

  getDefaultProps: ->
    limit: 5

  renderJobs: ->
    if (@props.jobs.get('jobs').count())
      @props.jobs.get('jobs').slice(0, @props.limit).map (job) ->
        React.createElement JobRow,
          job: job
          key: job.get 'id'
      .toArray().concat(@renderAllJobsLink())
    else
      div {},
        small {className: 'text-muted'},
          'No jobs found'

  render: ->
    React.DOM.div null,
      React.DOM.h4 null,
        'Last runs '
        React.createElement(Loader) if @props.jobs.get 'isLoading'
      React.DOM.div className: 'kbc-sidebar-jobs',
        @renderJobs()

  renderAllJobsLink: ->
    firstJob = @props.jobs.get('jobs')?.first()
    params = firstJob?.get('params')
    if not params
      return null
    if params.get('component')
      component = "+params.component:#{params.get('component')}"
    else
      component = "+component:#{firstJob.get('component')}"

    config = params.get('config')
    div className: 'jobs-link',
      React.createElement Link,
        to: 'jobs'
        query:
          q: "#{component} +params.config:#{config}"
      ,
        'Show all jobs'
