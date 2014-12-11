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

  _renderTable: ->
    div {className:"table"},
      @_renderTableHeader()
      div className: "tbody",
        div className: "tr",
          div className: "td", "ID"
          div className: "td", "status"
          div className: "td", "component"
          div className: "td", "Token"
          div className: "td", "Created Time"
          div className: "td", "Duration"





module.exports = JobsIndex
