Immutable = require('immutable')
StoreUtils = require('../../../utils/StoreUtils.coffee')
Constants = require('../Constants.coffee')
Dispatcher = require '../../../Dispatcher.coffee'
_ = require('underscore')

Map = Immutable.Map
List = Immutable.List

_store = Map(
  jobsById: Map()
  query:''
  isLoading: false
  isLoaded: false
  isLoadMore: true
  limit: 50
  offset: 0
  )

JobsStore = StoreUtils.createStore
  getJobsFiltered: ->
    filter = _store.get 'query'
    if not filter
      return getAll()

  getAll: ->
    _store
      .get('jobsById')
      .sortBy( (job) ->
        date = job.get 'createdTime'
        if date then -1 * (new Date(date).getTime()) else null
        )

  get: (id) ->
    _store.getIn ['jobsById', parseInt(id)]
  getPreviousOffset: ->
    _store.get 'previousOffset'
  getIsLoading: ->
    _store.get 'isLoading'

  getIsLoaded: ->
    _store.get 'isLoaded'

  getQuery: ->
    _store.get 'query'

  getLimit: ->
    _store.get 'limit'

  getOffset: ->
    _store.get 'offset'

  getNextOffset: ->
    _store.get('offset') + _store.get('limit')

  getIsLoadMore: ->
    _store.get 'isLoadMore'



Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.JOBS_LOAD
      _store = _store.set 'isLoading', true
      JobsStore.emitChange()

    #LOAD MORE JOBS FROM API and merge with current jobs
    when Constants.ActionTypes.JOBS_LOAD_SUCCESS
      currentJobs = _store.get('jobsById').toJS()
      currentJobs = {} if action.newOffset == 0
      loadMore = true
      limit = _store.get 'limit'
      loadMore = false if action.jobs.length < limit
      newJobs = _.uniq(_.union(_.values(currentJobs), _.first(action.jobs, _store.get('limit'))), (j) -> j.id)
      _store = _store.withMutations((store) ->
        store
          .set('isLoading', false)
          .set('isLoaded', true)
          .set('offset', action.newOffset)
          .set('jobsById', Immutable.fromJS(newJobs).toMap())
          .set('isLoadMore', loadMore)
      )
      JobsStore.emitChange()

    #RESET QUERY and OFFSET and jobs
    when Constants.ActionTypes.JOBS_SET_QUERY
      _store = _store.withMutations((store) ->
        store
          .set('query', action.query.trim())
          .set('offset',0)
          #.set('jobsById', Map())
      )
      JobsStore.emitChange()



module.exports = JobsStore
