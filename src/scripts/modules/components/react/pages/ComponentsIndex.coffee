React = require 'react'
_ = require 'underscore'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
InstalledComponentsStore = require '../../stores/InstalledComponentsStore'
ComponentsStore = require '../../stores/ComponentsStore'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'

Link = React.createFactory require('react-router').Link
ComponentConfigurationLink = React.createFactory require('../components/ComponentConfigurationLink')
ComponentIcon = React.createFactory(require '../../../../react/common/ComponentIcon')

NewComponentSelection = require '../components/NewComponentSelection'

{div, table, tbody, tr, td, ul, li, a, span, small} = React.DOM

TEXTS =
  noComponents:
    extractor: 'You don\'t have any extractors installed yet'
    writer: 'You don\'t have any writers installed yet'
  installFirst:
    extractor: 'Get started with your first extractor!'
    writer: 'Get started with your first writer!'


createComponentsIndex = (type) ->

  React.createClass
    displayName: 'InstalledComponents'
    mixins: [createStoreMixin(InstalledComponentsStore, ComponentsStore)]

    getStateFromStores: ->
      installedComponents: InstalledComponentsStore.getAllForType(type)
      components: ComponentsStore.getFilteredForType(type)
      filter: ComponentsStore.getFilter(type)

    render: ->
      console.log 'installed components', @state.installedComponents.toJS()
      if @state.installedComponents.count()
        rows =  @state.installedComponents.map((component) ->
          @renderComponentRow component
        , @).toArray()

        div className: 'container-fluid kbc-main-content',
          table className: 'table table-bordered kbc-table-full-width kbc-extractors-table',
            tbody null, rows
      else
        React.createElement NewComponentSelection,
          className: 'container-fluid kbc-main-content'
          components: @state.components
          filter: @state.filter
          componentType: type
        ,
          div className: 'row',
            React.DOM.h2 null, TEXTS['noComponents'][type]
            React.DOM.p null, TEXTS['installFirst'][type]

    renderComponentRow: (component) ->
      tr key: component.get('id'),
        td null,
          ComponentIcon
            component: component
            size: '32'
          component.get('name')
        td null, @renderConfigs(component)

    renderConfigs: (component) ->
      ul null,
        component.get('configurations').map((config) ->
          li key: config.get('id'),
            ComponentConfigurationLink
              componentId: component.get 'id'
              configId: config.get 'id'
            ,
              config.get 'name'
            span className: 'kbc-icon-arrow-right'
            if config.get 'description'
              small null, config.get('description')
        ).toArray()


module.exports = createComponentsIndex