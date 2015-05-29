React = require('react')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
JobsStore = require('../../../stores/JobsStore')
RoutesStore = require '../../../../../stores/RoutesStore'
ActionCreators = require('../../../ActionCreators')

QueryRow = React.createFactory(require('./QueryRow'))
JobRow = React.createFactory(require './JobRow')

{div, span,input, strong, form, button} = React.DOM

module.exports = React.createClass
  mixins: [createStoreMixin(JobsStore)]

  getStateFromStores: ->
    jobs: JobsStore.getAll()
    isLoading: JobsStore.getIsLoading()
    isLoaded: JobsStore.getIsLoaded()
    isLoadMore: JobsStore.getIsLoadMore()
    query: JobsStore.getQuery()

  _search: (query) ->
    ActionCreators.filterJobs(query)

  _loadMore: ->
    ActionCreators.loadMoreJobs()

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      QueryRow(onSearch: @_search, query: @state.query)
      @_renderTable()
      if @state.isLoadMore
        div className: 'kbc-block-with-padding',
          button onClick: @_loadMore, className: 'btn btn-default btn-large text-center',
            'More..'

  _renderTableHeader: ->
    div {className: 'thead' },
      div className: 'tr',
        span {className: 'th'},
          strong null, 'ID'
        span {className: 'th'},
          strong null, 'Status'
        span {className: 'th'},
          strong null, 'Component'
        span {className: 'th'},
          strong null, 'Action'
        span {className: 'th'},
          strong null, 'Token'
        span {className: 'th'},
          strong null, 'Created time'
        span {className: 'th'},
          strong null, 'Duration'


  _renderTable: ->
    div {className: 'table table-striped table-hover'},
      @_renderTableHeader(),
      div className: 'tbody',
        @state.jobs.map (job) ->
          JobRow
            job: job
            key: job.get('id')
            query: @state.query
        , @

