React = require 'react'
JobDetail = require('./react/pages/job-detail/JobDetail')
JobsIndex = require('./react/pages/jobs-index/JobsIndex')
JobsActionCreators = require('./ActionCreators')
JobsReloaderButton = require('./react/components/JobsReloaderButton')
JobDetailReloaderButton = require('./react/components/JobDetailReloaderButton')
JobDetailButtons = require './react/components/JobDetailButtons'
JobsStore = require('./stores/JobsStore')
Promise = require('bluebird')

routes =
      name: 'jobs'
      title: 'Jobs'
      path: 'jobs'
      defaultRouteHandler: JobsIndex
      reloaderHandler: JobsReloaderButton
      poll:
        interval: 10
        action: (params) ->
          JobsActionCreators.reloadJobs()
      requireData: [
        (params, query) ->
          currentQuery = JobsStore.getQuery()
          if params.jobId
            # job detail
            Promise.resolve()
          else if query.q != undefined && query.q != currentQuery
            JobsActionCreators.setQuery(query.q || "")
            JobsActionCreators.loadJobsForce(0, true, false)
          else
            JobsActionCreators.loadJobs()
        ]

      childRoutes: [
        name: 'jobDetail'
        path: ':jobId'
        title: (routerState) ->
          jobId = routerState.getIn(['params', 'jobId'])
          "Job " + jobId
        reloaderHandler: JobDetailReloaderButton
        isRunning: (routerState) ->
          jobId = routerState.getIn(['params', 'jobId'])
          job = JobsStore.get parseInt(jobId)
          job && !job.get('isFinished')

        handler: JobDetail
        headerButtonsHandler: JobDetailButtons
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
