React = require 'react'
_ = require 'underscore'

createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'
ComponentIcon = React.createFactory(require '../../../../react/common/ComponentIcon.coffee')
InstalledComponentsStore = require '../../stores/InstalledComponentsStore.coffee'
RoutesStore =  require '../../../../stores/RoutesStore.coffee'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators.coffee'
Link = React.createFactory require('react-router').Link

{div, table, tbody, tr, td, ul, li, a, span} = React.DOM

createComponentsIndex = (type) ->

  React.createClass
    displayName: 'InstalledComponents'
    mixins: [createStoreMixin(InstalledComponentsStore)]

    getStateFromStores: ->
      installedComponents: InstalledComponentsStore.getAllForType(type)

    render: ->
      rows =  @state.installedComponents.map((component) ->
        @renderComponentRow component
      , @).toArray()

      div className: 'container-fluid kbc-main-content',
        table className: 'table table-bordered kbc-table-full-width kbc-extractors-table',
          tbody null, rows

    renderComponentRow: (component) ->
      tr key: component.get('id'),
        td null,
          ComponentIcon(component: component, size: '32')
          component.get('name')
        td null, @renderConfigs(component)

    renderConfigs: (component) ->
      ul null,
        component.get('configurations').map((config) ->
          li key: config.get('id'),
            if RoutesStore.hasRoute(component.get('id'))
              Link
                to: component.get('id')
                params:
                  config: config.get('id')
              ,
                config.get('name')
            else
              span null,
                config.get('name')
            span className: 'kbc-icon-arrow-right'
        ).toArray()


module.exports = createComponentsIndex