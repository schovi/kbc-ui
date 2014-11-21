
EventEmitter = require('events').EventEmitter
Dispatcher = require '../dispatcher/KbcDispatcher.coffee'
assign = require 'object-assign'
Immutable = require('immutable')
Constants = require '../constants/KbcConstants.coffee'
fuzzy = require 'fuzzy'

_orchestrations = Immutable.fromJS([{"id":28213081,"name":"Weekly Orchestrator","configurationId":"sys.c-orchestrator.weekly","crontabRecord":"0 1 * * 6","createdTime":"2014-05-02T17:12:21+02:00","lastScheduledTime":"2014-11-15T01:00:04+00:00","nextScheduledTime":"2014-11-22T01:00:00+00:00","token":{"id":8042,"description":"Weekly Orchestrator"},"active":true,"uri":"https:\/\/syrup.keboola.com\/orchestrator\/orchestrations\/28213081"},{"id":28214062,"name":"Hourly Orchestrator","configurationId":"sys.c-orchestrator.hourly","crontabRecord":"0 14-23 * * *","createdTime":"2014-05-02T17:19:39+02:00","lastScheduledTime":"2014-11-15T16:00:04+00:00","nextScheduledTime":"2014-11-15T17:00:00+00:00","token":{"id":10058,"description":"Hourly Orchestrator"},"active":true,"uri":"https:\/\/syrup.keboola.com\/orchestrator\/orchestrations\/28214062","lastExecutedJob":{"id":59662479,"status":"success","createdTime":"2014-11-15T16:00:05+00:00","startTime":"2014-11-15T16:00:07+00:00","endTime":"2014-11-15T16:05:15+00:00"}},{"id":28215228,"name":"Hlavn\u00ed Orchestr\u00e1tor","configurationId":"sys.c-orchestrator.hlavni","crontabRecord":"15 23 * * *","createdTime":"2014-05-02T17:27:13+02:00","lastScheduledTime":"2014-11-14T23:15:02+00:00","nextScheduledTime":"2014-11-15T23:15:00+00:00","token":{"id":4127,"description":"Hlavn\u00ed Orchestr\u00e1tor"},"active":true,"uri":"https:\/\/syrup.keboola.com\/orchestrator\/orchestrations\/28215228","lastExecutedJob":{"id":59522586,"status":"success","createdTime":"2014-11-14T23:15:03+00:00","startTime":"2014-11-14T23:15:05+00:00","endTime":"2014-11-15T04:48:29+00:00"}},{"id":28219482,"name":"Custom Segments Update","configurationId":"sys.c-orchestrator.customSegmentsUpdate","crontabRecord":"0 9 * * *","createdTime":"2014-05-02T17:56:36+02:00","lastScheduledTime":null,"nextScheduledTime":null,"token":{"id":12314,"description":"Custom Segments Update Orchestrator"},"active":false,"uri":"https:\/\/syrup.keboola.com\/orchestrator\/orchestrations\/28219482","lastExecutedJob":{"id":59402151,"status":"success","createdTime":"2014-11-14T10:44:32+00:00","startTime":"2014-11-14T10:44:34+00:00","endTime":"2014-11-14T11:35:33+00:00"}},{"id":28220904,"name":"Daily Minor","configurationId":"sys.c-orchestrator.dailyMinor","crontabRecord":"30 4 * * *","createdTime":"2014-05-02T18:02:50+02:00","lastScheduledTime":"2014-11-15T04:30:02+00:00","nextScheduledTime":"2014-11-16T04:30:00+00:00","token":{"id":8038,"description":"Daily Minor Orchestrator"},"active":true,"uri":"https:\/\/syrup.keboola.com\/orchestrator\/orchestrations\/28220904","lastExecutedJob":{"id":59567678,"status":"error","createdTime":"2014-11-15T04:30:03+00:00","startTime":"2014-11-15T04:30:06+00:00","endTime":"2014-11-15T10:38:16+00:00"}},{"id":28221676,"name":"Daily Traffic","configurationId":"sys.c-orchestrator.dailyTraffic","crontabRecord":"15 0 * * *","createdTime":"2014-05-02T18:06:11+02:00","lastScheduledTime":"2014-11-15T00:15:03+00:00","nextScheduledTime":"2014-11-16T00:15:00+00:00","token":{"id":8039,"description":"Daily Traffic Orchestrator"},"active":true,"uri":"https:\/\/syrup.keboola.com\/orchestrator\/orchestrations\/28221676","lastExecutedJob":{"id":59532289,"status":"success","createdTime":"2014-11-15T00:15:03+00:00","startTime":"2014-11-15T00:15:06+00:00","endTime":"2014-11-15T05:06:42+00:00"}},{"id":41300808,"name":"Cleanup","configurationId":"sys.c-orchestrator.cleanup","crontabRecord":"0 19 * * *","createdTime":"2014-08-12T13:34:43+00:00","lastScheduledTime":"2014-11-14T19:00:07+00:00","nextScheduledTime":"2014-11-15T19:00:00+00:00","token":{"id":17854,"description":"Cleanup Orchestrator"},"active":true,"uri":"https:\/\/syrup.keboola.com\/orchestrator\/orchestrations\/41300808","lastExecutedJob":{"id":59483425,"status":"error","createdTime":"2014-11-14T19:00:07+00:00","startTime":"2014-11-14T19:00:10+00:00","endTime":"2014-11-14T21:50:52+00:00"}},{"id":48865813,"name":"Daily Exports","configurationId":"sys.c-orchestrator.daily-exports","crontabRecord":"0 20 * * *","createdTime":"2014-09-24T11:02:17+00:00","lastScheduledTime":"2014-11-14T20:00:12+00:00","nextScheduledTime":"2014-11-15T20:00:00+00:00","token":{"id":19110,"description":"Daily Exports"},"active":true,"uri":"https:\/\/syrup.keboola.com\/orchestrator\/orchestrations\/48865813","lastExecutedJob":{"id":59492776,"status":"success","createdTime":"2014-11-14T20:00:13+00:00","startTime":"2014-11-14T20:00:16+00:00","endTime":"2014-11-14T20:04:45+00:00"}},{"id":53041466,"name":"Plans Update","configurationId":"sys.c-orchestrator.plans-update","crontabRecord":"0 9 * * *","createdTime":"2014-10-14T09:28:30+00:00","lastScheduledTime":null,"nextScheduledTime":null,"token":{"id":21742,"description":"Plans Update Orchestrator"},"active":false,"uri":"https:\/\/syrup.keboola.com\/orchestrator\/orchestrations\/53041466","lastExecutedJob":{"id":58674363,"status":"success","createdTime":"2014-11-11T08:50:18+00:00","startTime":"2014-11-11T09:07:52+00:00","endTime":"2014-11-11T09:17:49+00:00"}}])

_filter = ''

CHANGE_EVENT = 'change'

itemIndex = (id) ->
  index = _orchestrations.findIndex((item) ->
    item.get('id') == id
  )

  if index == -1
    throw new Error("Cannot find item by id=" + id)

  index


updateItem = (id, payload) ->
  _orchestrations = _orchestrations.update(itemIndex(id), (orchestration) ->
    orchestration.merge payload
  )


OrchestrationStore = assign {}, EventEmitter.prototype,

  getAll: ->
    _orchestrations

  getFiltered: ->
    _orchestrations.filter((orchestration) ->
      if _filter
        fuzzy.match(_filter, orchestration.get('name'))
      else
        true
    )

  getFilter: ->
    _filter

  addChangeListener: (callback) ->
    @on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(CHANGE_EVENT, callback)

  emitChange: ->
    @emit(CHANGE_EVENT)


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.ORCHESTRATIONS_SET_FILTER
      _filter = action.query.trim()

    when Constants.ActionTypes.ORCHESTRATION_ACTIVATE
      updateItem action.orchestrationId,
        active: true

    when Constants.ActionTypes.ORCHESTRATION_DISABLE
      updateItem action.orchestrationId,
        active: false

  OrchestrationStore.emitChange()
  true

module.exports = OrchestrationStore