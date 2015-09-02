React = require 'react'
_ = require 'underscore'
{Map} = require 'immutable'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
InstalledComponentsStore = require '../../stores/InstalledComponentsStore'
ComponentsStore = require '../../stores/ComponentsStore'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'

Link = React.createFactory require('react-router').Link
ComponentConfigurationLink = React.createFactory require('../components/ComponentConfigurationLink')
ComponentIcon = React.createFactory(require '../../../../react/common/ComponentIcon')
ComponentRow = require './ComponentRow'

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


module.exports = React.createClass
  displayName: 'InstalledComponents'
  mixins: [createStoreMixin(InstalledComponentsStore, ComponentsStore)]
  propTypes:
    type: React.PropTypes.string.isRequired

  getStateFromStores: ->
    installedComponents: InstalledComponentsStore.getAllForType(@props.type)
    deletingConfigurations: InstalledComponentsStore.getDeletingConfigurations()
    components: ComponentsStore.getFilteredForType(@props.type)
    filter: ComponentsStore.getFilter(@props.type)

  render: ->
    if @state.installedComponents.count()
      rows =  @state.installedComponents.map((component) ->
        React.createElement ComponentRow,
          component: component
          deletingConfigurations: @state.deletingConfigurations.get(component.get('id'), Map())
          key: component.get('id')
      , @).toArray()

      div className: 'container-fluid kbc-main-content kbc-components-list',
        rows
    else
      React.createElement NewComponentSelection,
        className: 'container-fluid kbc-main-content'
        components: @state.components
        filter: @state.filter
        componentType: @props.type
      ,
        div className: 'row',
          React.DOM.h2 null, TEXTS['noComponents'][@props.type]
          React.DOM.p null, TEXTS['installFirst'][@props.type]
