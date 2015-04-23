React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
JobsStore = require('../../../stores/JobsStore')
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
RoutesStore = require '../../../../../stores/RoutesStore'
ActionCreators = require('../../../ActionCreators')


QueryRow = React.createFactory(require('./QueryRow'))

ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))
JobStatusLabel = React.createFactory(require '../../../../../react/common/JobStatusLabel')
Duration = React.createFactory(require('../../../../../react/common/Duration'))
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName')
date = require '../../../../../utils/date'

{div, span,input, strong, form, button} = React.DOM
JobsIndex = React.createClass
  mixins: [createStoreMixin(JobsStore, ComponentsStore)]

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

  _unknownComponent: (name) ->
    result =
      id: name
      name: name
      type: 'unknown'
    return Immutable.fromJS(result)

  _renderTableRow: (row,idx) ->
    rowComponent = ComponentsStore.getComponent(row.get 'component')
    if not rowComponent
      rowComponent = @_unknownComponent(row.get 'component')

    Link {className: 'tr', to: 'jobDetail', params: {jobId: row.get('id')}, query: {q: @state.query}},
      div className: 'td', row.get('id')
      div className: 'td', JobStatusLabel {status: row.get 'status'}
      div className: 'td',
        ComponentIcon {component: rowComponent, size: '32'}
        ' '
        ComponentName {component: rowComponent}
      div className: 'td', row.get 'command'
      div className: 'td', row.getIn ['token', 'description']
      div className: 'td',
        date.format(row.get('createdTime'))
      div className: 'td',
        Duration {startTime: row.get('startTime'), endTime: row.get('endTime')}


  _renderTable: ->
    console.log 'rendering table'
    idx = 0
    div {className: 'table table-striped table-hover'},
      @_renderTableHeader(),
      div className: 'tbody',
        @state.jobs.map((job) ->
          idx++
          @_renderTableRow(job, idx)

        , @).toArray()







module.exports = JobsIndex
