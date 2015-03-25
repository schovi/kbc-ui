React = require  'react'
_ = require 'underscore'

Link = React.createFactory(require('react-router').Link)

AppsStore = require '../../../KbcAppsStore'
App = React.createFactory(require('./AppItem'))

{div, span,input, strong, form, button} = React.DOM

AppsIndex = React.createClass
  displayName: 'Applications'
  render: ->
    apps = @_prepareApps(@_getApps())
    appRows = _.map(apps, (appsInRow) ->
      @_renderAppsRow(appsInRow)
    , @)

    (div className: 'container kbc-applications',
      (div className: 'row',
        (div className: 'col-md-12',
          appRows
        )
      )
    )

  _getApps: ->
    AppsStore.getKbcApps()

  _renderAppsRow: (apps) ->
    appElements = _.map(apps, (app) ->
      App(app: app)
    , @)

    (div className: 'row', appElements)

  _prepareApps: (apps) ->
    _.chain(apps.toJS())
    .sortBy('id')
    .groupBy (index) ->
      Math.floor(index++ / 3)
    .toArray()
    .value()

module.exports = AppsIndex
