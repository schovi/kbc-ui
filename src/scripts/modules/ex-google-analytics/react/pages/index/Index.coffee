React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGanalStore = require '../../../exGanalStore'
RoutesStore = require '../../../../../stores/RoutesStore'
QueriesTable = React.createFactory(require('./QueriesTable'))
#RunExtraction = React.createFactory(require '../../components/RunExtraction')

ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)
Link = React.createFactory(require('react-router').Link)

{strong, br, ul, li, div, span, i} = React.DOM

module.exports = React.createClass
  displayName: 'ExGanalIndex'
  mixins: [createStoreMixin(ExGanalStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    config: ExGanalStore.getConfig(configId)
    configId: configId

  render: ->
    console.log 'rendering', @state.config.toJS()
    div {className: 'container-fluid'},
      @_renderMainContent()
      @_renderSideBar()

  _renderMainContent: ->
    queries = @state.config.get('configuration')
    div {className: 'col-md-9 kbc-main-content'},
      div className: 'row kbc-header',
        div className: 'col-sm-8',
          ComponentDescription
            componentId: 'ex-google-analytics'
            configId: @state.configId
        div className: 'col-sm-4 kbc-buttons',
          Link
            to: 'ex-google-analytics-new-query'
            params:
              config: @state.configId
            className: 'btn btn-success'
          ,
            i className: 'fa fa-fw fa-plus'
            'Add Query'
      if queries.count()
        QueriesTable
          queries: queries
          profiles: @state.config.get 'items'
          configId: @state.configId
      else
        "no queries yet"

  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      ul className: 'nav nav-stacked',
        li null,
          Link
            to: 'ex-google-analytics-authorize'
            params:
              config: @state.configId
          ,
            i className: 'fa fa-fw fa-user'
            'Authorize'
        li null,
          Link
            to: 'ex-google-analytics-select-profiles'
            params:
              config: @state.configId
          ,
            span className: 'fa fa-fw fa-check'
            'Select Profiles'

        # li null,
        #   RunExtraction
        #     component: 'ex-google-analytics'
        #     runParams:
        #       account: @state.configId
      div className: 'kbc-buttons',
        span null,
          'Created By '
        strong null, 'Damien Dickhead'
        br null
        span null,
          'Created On '
        strong null, '2014-05-07 09:24 '
