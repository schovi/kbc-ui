React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

ComponentSelect = React.createFactory(require './ComponentSelect')
ConfigurationSelect = React.createFactory(require './ConfigurationSelect')
OrchestrationSelect = React.createFactory(require './OrchestrationSelect')
ComponentsReloaderButton = require '../../components/ComponentsReloaderButton'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
RoutesStore = require '../../../../../stores/RoutesStore'
OrchestrationStore = require '../../../stores/OrchestrationsStore'
ApplicationStore = require '../../../../../stores/ApplicationStore'

require './AddTaskModal.less'

SearchRow = React.createFactory(require('../../../../../react/common/SearchRow').default)
fuzzy = require 'fuzzy'
immutableMixin = require '../../../../../react/mixins/ImmutableRendererMixin'


STEP_COMPONENT_SELECT = 'componentSelect'
STEP_CONFIGURATION_SELECT = 'configurationSelect'
STEP_ORCHESTRATOR_CONFIGURATION_SELECT = 'orchestratorConfigurationSelect'

{div, p, strong, h2, a} = React.DOM

AddTaskModal = React.createClass
  displayName: 'AddTaskModal'
  mixins: [createStoreMixin(InstalledComponentsStore, OrchestrationStore), immutableMixin]
  propTypes:
    onConfigurationSelect: React.PropTypes.func.isRequired
    onHide: React.PropTypes.func
    show: React.PropTypes.bool
    phaseId: React.PropTypes.string
    searchQuery: React.PropTypes.string
    onChangeSearchQuery: React.PropTypes.func.isRequired

  getInitialState: ->
    selectedComponent: null
    currentStep: STEP_COMPONENT_SELECT

  getStateFromStores: ->
    orchestrationId = RoutesStore.getCurrentRouteIntParam 'orchestrationId'
    currentOrchestration = OrchestrationStore.get orchestrationId
    return {
      components: InstalledComponentsStore.getAll().filter (c) ->
        !c.get('flags').includes('excludeRun')
      orchestrations: OrchestrationStore.getAll().filter((orchestration) ->
        !orchestration.get('crontabRecord') && currentOrchestration.get('id') != orchestration.get('id')
      )
    }

  _getFilteredComponents: ->
    filter = @props.searchQuery
    @state.components.filter (c) ->
      fuzzy.match(filter, c.get('name', '')) || fuzzy.match(filter, c.get('id', ''))

  _getFilteredOrchestrations: ->
    filter = @props.searchQuery
    @state.orchestrations.filter ->
      fuzzy.match(filter, 'orchestrator')

  render: ->
    Modal
      title: @_modalTitle()
      onRequestHide: @props.onHide
      show: @props.show

      div className: 'modal-body',
        switch @state.currentStep
          when STEP_COMPONENT_SELECT
            div null,
              SearchRow
                query: @props.searchQuery
                onChange: @props.onChangeSearchQuery
              div className: 'orchestration-task-modal-body',
                ComponentSelect
                  orchestrations: @_getFilteredOrchestrations()
                  components: @_getFilteredComponents()
                  onComponentSelect: @_handleComponentSelect
          when STEP_CONFIGURATION_SELECT
            div className: 'orchestration-task-modal-body',
              ConfigurationSelect
                component: @state.selectedComponent
                onReset: @_handleComponentReset
                onConfigurationSelect: @_handleConfigurationSelect

          when STEP_ORCHESTRATOR_CONFIGURATION_SELECT
            div className: 'orchestration-task-modal-body',
              OrchestrationSelect
                component: @state.selectedComponent
                orchestrations: @state.orchestrations
                onReset: @_handleComponentReset
                onConfigurationSelect: @_handleConfigurationSelect

      div className: 'modal-footer',
        ButtonToolbar null,
          Button
            bsStyle: 'link'
            onClick: @props.onHide
          ,
            'Cancel'

  _modalTitle: ->
    React.DOM.h4 className: 'modal-title',
      "Add new task to #{@props.phaseId} "
      React.createElement ComponentsReloaderButton

  _handleComponentSelect: (component) ->
    @setState
      selectedComponent: component
      currentStep:
        if component.get('id') == 'orchestrator'
          STEP_ORCHESTRATOR_CONFIGURATION_SELECT
        else
          STEP_CONFIGURATION_SELECT

  _handleComponentReset: ->
    @setState
      selectedComponent: null
      currentStep: STEP_COMPONENT_SELECT

  ###
    Configuration is selected
    close modal with selected configuration
  ###
  _handleConfigurationSelect: (configuration) ->
    #@props.onRequestHide() # hide modal
    @props.onConfigurationSelect(@state.selectedComponent, configuration, @props.phaseId)
    @props.onHide()




module.exports = AddTaskModal
