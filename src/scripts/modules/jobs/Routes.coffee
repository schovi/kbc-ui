React = require 'react'
JobDetail = require('./react/pages/job-detail/JobDetail.coffee')
JobsIndex = require('./react/pages/jobs-index/JobsIndex.coffee')
JobsActionCreators = require('./ActionCreators.coffee')
JobsReloaderButton = require('./react/components/JobsReloaderButton.coffee')
routes =
      name:'jobs'
      title: 'Jobs'
      defaultRouteHandler: JobsIndex
      reloaderHandler: JobsReloaderButton
      requireData: [
        (params) ->
          JobsActionCreators.loadJobs()
        ]

      childRoutes: [
        name:'jobDetail'
        path: ':jobId'
        title: 'Job Detail'
        handler: JobDetail
        # requireData:
        #   [
        #     (params) ->
        #       JobsActionCreators.loadJobDetail(params.jobId)
        #     ]

        ]

module.exports = routes
