React = require  'react'

Link = React.createFactory(require('react-router').Link)

AppsStore = require '../../../KbcAppsStore'
App = React.createFactory(require('./AppItem'))

{div, span,input, strong, form, button} = React.DOM

module.exports = React.createClass
  displayName: 'Applications'

  getInitialState: ->
    components: AppsStore.getKbcApps()

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'table kbc-table-border-vertical kbc-components-overview kbc-layout-table',
        div className: 'tbody',
          @state.components
          .toIndexedSeq()
          .sortBy (component) -> component.get('name')
          .groupBy (component, i) -> Math.floor(i / 3)
          .map @_renderAppsRow, @
          .toArray()

  _renderAppsRow: (apps, key) ->
    div
      className: 'tr'
      key: key
    ,
      apps.map (app) ->
        App
          app: app
          key: app.get 'id'
      .toArray()
