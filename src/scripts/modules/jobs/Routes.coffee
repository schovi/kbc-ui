React = require 'react'
JobDetail = require('./react/pages/job-detail/JobDetail.coffee')
JobsIndex = require('./react/pages/jobs-index/JobsIndex.coffee')
JobsActionCreators = require('./ActionCreators.coffee')
JobsReloaderButton = require('./react/components/JobsReloaderButton.coffee')
JobDetailReloaderButton = require('./react/components/JobDetailReloaderButton.coffee')
JobStatusLabel = React.createFactory(require '../../react/common/JobStatusLabel.coffee')
JobsStore = require('./stores/JobsStore.coffee')

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
        (params) ->
          JobsActionCreators.loadJobs()
        ]

      childRoutes: [
        name: 'jobDetail'
        path: ':jobId'
        title: (routerState) ->
          jobId = routerState.getIn(['params', 'jobId'])
          React.DOM.span null,"Job " + jobId
        reloaderHandler: JobDetailReloaderButton
        handler: JobDetail
        poll:
          interval: 10
          action: (params) ->
            jobId = params.jobId
            job = JobsStore.get jobId
            if job and job.get('status') in ['waiting','processing']
              JobsActionCreators.loadJobDetail(params.jobId)

        requireData:
          [
            (params) ->
              JobsActionCreators.loadJobDetail(params.jobId)
            ]
        ]

module.exports = routes
