React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
ExGdriveStore = require '../../../exGdriveStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

RunExtraction = React.createFactory(require '../../components/RunExtraction.coffee')
ComponentDescription = require '../../../../components/react/components/ComponentDescription.coffee'
ComponentDescription React.createFactory ComponentDescription
Link = React.createFactory(require('react-router').Link)

ItemsTable = require './ItemsTable.coffee'

{strong, br, ul, li, div, span, i} = React.DOM

module.exports = React.createClass
  mixins: [createStoreMixin(ExGdriveStore)]

  getStateFromStores: ->
    config =  RoutesStore.getRouterState().getIn ['params', 'config']
    configuration: ExGdriveStore.getConfig(config)

  _renderMainContent: ->
    items = @state.configuration.get('items')
    div {className: 'col-md-9 kbc-main-content'},
      div className: 'row kbc-header',
        div className: 'col-sm-8',
          ComponentDescription
            componentId: 'ex-google-drive'
            configId: @state.configuration.get('id')
        div className: 'col-sm-4 kbc-buttons',
          Link
            to: 'ex-google-drive-new-query'
            params:
              config: @state.configuration.get 'id'
            className: 'btn btn-success'
          ,
            span className: 'kbc-icon-plus'
            ' Add Query'
      if items.count()
        ItemsTable
          items: items
          configurationId: @state.configuration.get 'id'
      else
        "no queries yet"

  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      ul className: 'nav nav-stacked',
        li null,
          Link
            to: 'ex-google-drive-authorize'
            params:
              config: @state.configuration.get 'id'
          ,
            i className: 'fa fa-fw fa-user'
            ' Authorize'
        li null,
          RunExtraction
            configId: @state.configuration.get 'id'
      div className: 'kbc-buttons',
        span null,
          'Created By '
        strong null, 'Damien Dickhead'
        br null
        span null,
          'Created On '
        strong null, '2014-05-07 09:24 '


  render: ->
    console.log @state.configuration.toJS()
    div {className: 'container-fluid'},
      @_renderMainContent()
      @_renderSideBar()
