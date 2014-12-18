React = require('react')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'
JobsStore = require('../../../stores/JobsStore.coffee')


JobDetail = React.createClass
  mixins: [createStoreMixin(JobsStore)]

  getStateFromStores: ->
    jobId = RoutesStore.getRouterState().getIn ['params','jobId']
    job: JobsStore.get jobId

  render: ->
    console.log @state.job.toJS()
    React.DOM.span null,"TODO detail"


module.exports = JobDetail
