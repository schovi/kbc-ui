React = require('react')
Link = React.createFactory(require('react-router').Link)
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
JobsStore = require('../../../stores/JobsStore.coffee')

{div, span, strong} = React.DOM

JobsIndex = React.createClass
  mixins: [createStoreMixin(JobsStore)]

  getStateFromStores: ->
    jobs: JobsStore.getAll()
    isLoading: JobsStore.getIsLoading()
    isLoaded: JobsStore.getIsLoaded()


  render: ->
    div {className: 'container-fluid'},
      @_renderTable()

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

  _renderTableRow: (row) ->
    div {className: "tr", key:row.get 'id'},
      div className: "td", row.get 'id'
      div className: "td", row.get 'status'
      div className: "td", row.get 'component'
      div className: "td", row.getIn ['token','description']
      div className: "td", row.get 'createdTime'
      div className: "td", row.get 'durationSeconds'


  _renderTable: ->
    console.log "rendering table"
    div {className:"table"},
      @_renderTableHeader(),
      div className: "tbody",
        @state.jobs.map((job) ->
          @_renderTableRow(job)
        , @).toArray()







module.exports = JobsIndex
