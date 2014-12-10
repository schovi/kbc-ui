React = require 'react'
JobsIndex = React.createClass
  render: ->
    React.DOM.span null,"TODO"

JobDetail = React.createClass
  render: ->
    React.DOM.span null,"TODO detail"


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
