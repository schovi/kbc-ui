React = require 'react'
JobDetail = require('./react/pages/job-detail/JobDetail')
JobsIndex = require('./react/pages/jobs-index/JobsIndex')
JobsActionCreators = require('./ActionCreators')
JobsReloaderButton = require('./react/components/JobsReloaderButton')
JobDetailReloaderButton = require('./react/components/JobDetailReloaderButton')
JobTerminateButton = require './react/components/JobTerminateButton'
JobStatusLabel = React.createFactory(require '../../react/common/JobStatusLabel')
JobsStore = require('./stores/JobsStore')

routes =
      name: 'jobs'
      title: 'Jobs'
      defaultRouteHandler: JobsIndex
      reloaderHandler: JobsReloaderButton
      poll:
        interval: 10
        action: (params) ->
          JobsActionCreators.reloadJobs()
      requireData: [
        (params, query) ->
          if query.q
            JobsActionCreators.filterJobs query.q
          else
            JobsActionCreators.filterJobs ''
        ]

      childRoutes: [
        name: 'jobDetail'
        path: ':jobId'
        title: (routerState) ->
          jobId = routerState.getIn(['params', 'jobId'])
          "Job " + jobId
        reloaderHandler: JobDetailReloaderButton
        handler: JobDetail
        headerButtonsHandler: JobTerminateButton
        poll:
          interval: 2
          action: (params) ->
            jobId = parseInt(params.jobId)
            job = JobsStore.get jobId
            if job and job.get('status') in ['waiting','processing','terminating']
              JobsActionCreators.loadJobDetailForce(jobId)
        requireData: [
          (params) ->
            JobsActionCreators.loadJobDetail(parseInt(params.jobId))
        ]
      ]

module.exports = routes
