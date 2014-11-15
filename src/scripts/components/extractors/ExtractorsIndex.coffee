React = require 'react'
_ = require 'underscore'

ComponentIcon = React.createFactory(require '../common/ComponentIcon.coffee')
InstalledComponentsStore = require '../../stores/InstalledComponentsStore.coffee'

{div, table, tbody, tr, td, ul, li, a, span} = React.DOM

getStateFromStores = ->
  installedComponents: InstalledComponentsStore.getAll()

Extractors = React.createClass
  displayName: 'InstalledComponents'
  getInitialState: ->
    getStateFromStores()
  render: ->
    div className: 'container-fluid',
      table className: 'table table-bordered kbc-table-full-width kbc-extractors-table',
        tbody null,
        _.map(@state.installedComponents, (component) ->
          @renderComponentRow component
        , @)

  renderComponentRow: (component) ->
    tr key: component.id,
      td null,
        ComponentIcon(component: component, size: '32')
        component.name
      td null,
        @renderConfigs(component.configurations)
  renderConfigs: (configurations) ->
    ul null,
      _.map(configurations, (config) ->
        li null,
          a null,
            config.name
          span className: 'kbc-icon-arrow-right'
      )


module.exports = Extractors