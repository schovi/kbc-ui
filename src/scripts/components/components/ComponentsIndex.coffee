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

    rows =  @state.installedComponents.map((component) ->
      @renderComponentRow component
    , @).toArray()

    div className: 'container-fluid',
      table className: 'table table-bordered kbc-table-full-width kbc-extractors-table',
        tbody null, rows


  renderComponentRow: (component) ->
    tr key: component.get('id'),
      td null,
        ComponentIcon(component: component, size: '32')
        component.get('name')
      td null, @renderConfigs(component.get('configurations'))

  renderConfigs: (configurations) ->
    ul null,
      configurations.map((config) ->
        li key: config.get('id'),
          a null,
            config.get('name')
          span className: 'kbc-icon-arrow-right'
      ).toArray()


module.exports = ComponentsIndex