React = require('react')
Link = React.createFactory(require('react-router').Link)
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
JobsStore = require('../../../stores/JobsStore.coffee')
ComponentsStore  = require('../../../../components/stores/ComponentsStore.coffee')


ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon.coffee'))
JobStatusLabel = React.createFactory(require '../../../../../react/common/JobStatusLabel.coffee')
Duration = React.createFactory(require('../../../../../react/common/Duration.coffee'))
ComponentName = React.createFactory(require '../../../../../react/common/ComponentName.coffee')
date = require '../../../../../utils/date.coffee'

{div, span, strong} = React.DOM

JobsIndex = React.createClass
  mixins: [createStoreMixin(JobsStore,ComponentsStore)]

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
    rowComponent = ComponentsStore.getComponent(row.get 'component')
    div {className: "tr", key:row.get 'id'},
      div className: "td", row.get 'id'
      div className: "td", JobStatusLabel {status: row.get 'status'}
      div className: "td",
        ComponentIcon {component: rowComponent, size:"32"}
        ComponentName {component: rowComponent}
      div className: "td", row.getIn ['token','description']
      div className: "td",
        date.format(row.get('createdTime'))
      div className: "td",
        Duration {startTime: row.get('startTime'), endTime: row.get('endTime')}


  _renderTable: ->
    console.log "rendering table"
    div {className:"table"},
      @_renderTableHeader(),
      div className: "tbody",
        @state.jobs.map((job) ->
          @_renderTableRow(job)
        , @).toArray()







module.exports = JobsIndex
