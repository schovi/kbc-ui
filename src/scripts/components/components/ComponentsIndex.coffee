React = require 'react'
_ = require 'underscore'

ComponentIcon = React.createFactory(require '../common/ComponentIcon.coffee')
InstalledComponentsStore = require '../../stores/InstalledComponentsStore.coffee'
InstalledComponentsActionCreators = require '../../actions/InstalledComponentsActionCreators.coffee'

{div, table, tbody, tr, td, ul, li, a, span} = React.DOM

createComponentsIndex = (type) ->


  getStateFromStores = ->
    installedComponents: InstalledComponentsStore.getAllForType(type)

  React.createClass
    displayName: 'InstalledComponents'

    getInitialState: ->
      getStateFromStores()

    componentDidMount: ->
      InstalledComponentsStore.addChangeListener(@_onChange)

    componentWillUnmount: ->
      InstalledComponentsStore.removeChangeListener(@_onChange)

    _onChange: ->
      @setState(getStateFromStores())

    _onRefresh: ->
      InstalledComponentsActionCreators.loadComponentsForce()

    render: ->
      rows =  @state.installedComponents.map((component) ->
        @renderComponentRow component
      , @).toArray()

      div className: 'container-fluid',
        span className: 'fa fa-refresh', onClick: @_onRefresh
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


module.exports = createComponentsIndex