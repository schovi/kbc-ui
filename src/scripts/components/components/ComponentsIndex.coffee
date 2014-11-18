React = require 'react'
_ = require 'underscore'

ComponentIcon = React.createFactory(require '../common/ComponentIcon.coffee')
InstalledComponentsStore = require '../../stores/InstalledComponentsStore.coffee'

{div, table, tbody, tr, td, ul, li, a, span} = React.DOM

getStateFromStores = (type) ->
  installedComponents: InstalledComponentsStore.getAllForType(type)

ComponentsIndex = React.createClass
  displayName: 'InstalledComponents'
  getInitialState: ->
    getStateFromStores(@props.mode)
  componentWillReceiveProps: (nextProps) ->
    @setState(getStateFromStores(nextProps.mode))
  render: ->
    console.log 'render components'
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
        li key: config.id,
          a null,
            config.name
          span className: 'kbc-icon-arrow-right'
      )


module.exports = ComponentsIndex