React = require('react')
Link = React.createFactory(require('react-router').Link)
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
JobsStore = require('../../../stores/JobsStore.coffee')
ComponentsStore  = require('../../../../components/stores/ComponentsStore.coffee')
ActionCreators = require('../../../ActionCreators.coffee')

QueryRow = React.createFactory(require('./QueryRow.coffee'))

ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon.coffee'))
JobStatusLabel = React.createFactory(require '../../../../../react/common/JobStatusLabel.coffee')
Duration = React.createFactory(require('../../../../../react/common/Duration.coffee'))
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName.coffee')
date = require '../../../../../utils/date.coffee'

{div, span,input, strong, form, button} = React.DOM
JobsIndex = React.createClass
  mixins: [createStoreMixin(JobsStore,ComponentsStore)]

  getStateFromStores: ->
    jobs: JobsStore.getAll()
    isLoading: JobsStore.getIsLoading()
    isLoaded: JobsStore.getIsLoaded()
    isLoadMore: JobsStore.getIsLoadMore()
    query:JobsStore.getQuery()

  _search: (query)->
    ActionCreators.filterJobs(query)
    return

  _loadMore: ->
    ActionCreators.loadMoreJobs()

  render: ->
    div {className: 'container-fluid'},
      QueryRow(onSearch:@_search, query:@state.query)
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
          strong null, 'Token'
        span {className: 'th'},
          strong null, 'Created time'
        span {className: 'th'},
          strong null, 'Duration'

  _renderTableRow: (row,idx) ->
    rowComponent = ComponentsStore.getComponent(row.get 'component')
    div {className: "tr", key:row.get 'id'},
      div className: "td", row.get('id')
      div className: "td", JobStatusLabel {status: row.get 'status'}
      div className: "td",
        ComponentIcon {component: rowComponent, size:"32"}
        ' '
        ComponentName {component: rowComponent}
      div className: "td", row.getIn ['token','description']
      div className: "td",
        date.format(row.get('createdTime'))
      div className: "td",
        Duration {startTime: row.get('startTime'), endTime: row.get('endTime')}


  _renderTable: ->
    console.log "rendering table"
    idx = 0
    div {className:"table"},
      @_renderTableHeader(),
      div className: "tbody",
        @state.jobs.map((job) ->
          idx++
          @_renderTableRow(job,idx)

        , @).toArray()







module.exports = JobsIndex
