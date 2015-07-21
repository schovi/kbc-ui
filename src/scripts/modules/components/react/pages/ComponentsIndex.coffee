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

{div, table, tbody, tr, td, ul, li, a, span, small, strong} = React.DOM

TEXTS =
  noComponents:
    extractor: 'Extractors allows you to collect data from various sources.'
    writer: 'Writers allows you to send data to various destinations.'
    application: 'Use applications to enhance, modify or better understand your data.'
  installFirst:
    extractor: 'Get started with your first extractor!'
    writer: 'Get started with your first writer!'
    application: 'Get started with your first application!'


module.exports = (type) ->

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

        div className: 'container-fluid kbc-main-content kbc-components-list',
          rows
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
      div null,
        div {className: 'kbc-header', key: component.get('id')},
          div {className: 'kbc-title'},
            React.DOM.h2 null,
              ComponentIcon
                component: component
                size: '32'
              component.get('name')
        table {className: 'table table-hover'},
          @renderConfigs(component)

    renderConfigs: (component) ->
      tbody null,
        component.get('configurations').map((config) ->
          tr null,
            td key: config.get('id'),
              ComponentConfigurationLink
                componentId: component.get 'id'
                configId: config.get 'id'
              ,
                strong className: 'kbc-config-name',
                  if config.get 'name'
                    config.get 'name'
                  else
                    '---'
                if config.get 'description'
                  small null, ' - ' + config.get('description')
            td className: 'text-right kbc-component-buttons',
              span className: 'kbc-component-author',
                'Created By '
                strong null, 'Martin'
              React.DOM.button className: 'btn btn-link',
                React.DOM.span className: 'kbc-icon-cup'
              React.DOM.button className: 'btn btn-link',
                React.DOM.span className: 'fa fa-fw fa-play'

        ).toArray()
