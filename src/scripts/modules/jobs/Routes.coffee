React = require 'react'
JobDetail = require('./react/pages/job-detail/JobDetail.coffee')
JobsIndex = require('./react/pages/jobs-index/JobsIndex.coffee')

console.log JobDetail, JobsIndex
routes =
      name:'jobs'
      title: 'Jobs'
      defaultRouteHandler: JobsIndex
      # requireData: [
      #   (params) ->
      #     JobsActionCreators.loadJobs()
      #   ]
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
